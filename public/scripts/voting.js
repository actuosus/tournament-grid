/**
 * voting
 * @author: actuosus
 * @fileOverview
 * Date: 29/08/2013
 * Time: 01:35
 * @requires jQuery
 */

(function (global) {
  var votingUrl = '/vote.php';
  var variantCount = 1;
  var voteResultsTemplate;
  var voteTemplate;
  var voteAdminTemplate;
  var noVotingTemplate;
  var container;
  var streamId;

  String.prototype.__format = function() {
    var args = arguments;
    return this.replace(/{(\d+)}/g, function(match, number) {
      return typeof args[number] != 'undefined'
        ? args[number]
        : match
        ;
    });
  };

  function prepareDataForVoting($form) {
    var title = $('.voting-title', $form).val();
    var variants = [];
    $('.b-stream__voting-variant', $form).each(function (index, variant) {
      variants.push({
        index: index,
        title: $('.variant-title', variant).val(),
        color: $('.variant-color', variant).val()
      });
    });
    return {
      title: title,
      createdAt: Date.now(),
      variants: variants
    }
  }

  function createVotingView(data) {
    var votingViewTemplate = $.parseHTML(voteTemplate);
    var votingVariantTemplate = $('.b-stream__voting__variant-template', votingViewTemplate).detach().clone();
    var variants = data.variants;
    var variantsHolder = $('.b-stream__voting__variants', votingViewTemplate);
    for (var i = 0; i < variants.length; i++) {
      var variant = variants[i];
      var variantElement = votingVariantTemplate.clone();
      var id = 'variant-id-' + i;
      $('.variant-radio', variantElement).attr({id: id}).data('index', i);
      $('.variant-title', variantElement).text(variant.title).attr({for: id});
      variantsHolder.append(variantElement);
      console.log('Binding click to', variantElement.get(0));
      variantElement.on('change', function (event) {
        console.log('Kind of voting', event);
        vote($('.variant-radio', this).data('index'), {
          success: function(data) {
            showAppropriateView(data);
          },
          error: function(jXHR) {
            console.log('Some error', jXHR);
          }
        });
      });
    }
    $('.title', votingViewTemplate).text(data.title);
    return votingViewTemplate;
  }

  /**
   * Функция возвращает окончание для множественного числа слова на основании числа и массива окончаний
   * @param  iNumber Integer Число на основе которого нужно сформировать окончание
   * @param  aEndings Array Массив слов или окончаний для чисел (1, 4, 5),
   *         например ['яблоко', 'яблока', 'яблок']
   * @return String
   */
  function getNumEnding(iNumber, aEndings) {
    var sEnding, i;
    iNumber = iNumber % 100;
    if (iNumber >= 11 && iNumber <= 19) {
      sEnding = aEndings[2];
    }
    else {
      i = iNumber % 10;
      switch (i) {
        case (1):
          sEnding = aEndings[0];
          break;
        case (2):
        case (3):
        case (4):
          sEnding = aEndings[1];
          break;
        default:
          sEnding = aEndings[2];
      }
    }
    return sEnding;
  }

  function padLeft(nr, n, str) {
    return Array(n - String(nr).length + 1).join(str || '0') + nr;
  }

  function formatDate(timeStamp) {
//  23.08.2012
    var date = new Date(timeStamp);
    return padLeft(date.getDay(), 2) + '.' + padLeft(date.getMonth() + 1, 2) + '.' + (date.getFullYear());
  }

  function createVotingResultsView(data) {
    var votingResultsViewTemplate = $.parseHTML(voteResultsTemplate);
    var votingVariantTemplate = $('.b-stream__voting-results-variant-template', votingResultsViewTemplate).detach().clone();
    var variants = data.variants;
    var variantsHolder = $('.b-stream__voting__graph', votingResultsViewTemplate);
    var fullCount = 0;
    for (var i = 0; i < variants.length; i++) {
      var variant = variants[i];
      fullCount += (variant.count || 0);
    }
    for (var i = 0; i < variants.length; i++) {
      var variant = variants[i];
      var id = 'variant-id-' + i;
      var percentage = Math.round((fullCount ? variant.count / fullCount : 0) * 100) || 0;
      var variantElement = votingVariantTemplate.clone();
      $(variantElement).addClass('item_type' + (i + 1));
      $('.item__limiter', variantElement).css({width: percentage + '%'});
      $('.variant-title', variantElement).text(variant.title).attr({for: id});
      $('.variant-percentage', variantElement).text(percentage + '%');
      $('.item__quantity', variantElement).text('(' + (variant.count || 0) + ')');
      variantsHolder.append(variantElement);
    }
    $('.b-stream__voting__users-count-string', votingResultsViewTemplate).text(
      getNumEnding(fullCount, ['проголосвал', 'проголосвало', 'проголосвали']) + ' ' +
        fullCount + ' ' + getNumEnding(fullCount, ['пользователь', 'пользователя', 'пользователей'])
    );
    $('.b-stream__voting__created-at', votingResultsViewTemplate).text(formatDate(parseInt(data.createdAt, 10)));
    $('.title', votingResultsViewTemplate).text(data.title);
    if (data.moderator) {
      $('<button class="delete-button">Delete</button>').appendTo(votingResultsViewTemplate).click(function(){
        deleteVoting();
      });
    }
    return votingResultsViewTemplate;
  }

  function showAppropriateView(data) {
    var view;
    if (data) {
      if (data.voted) {
        view = createVotingResultsView(data);
      } else if (data.moderator && !data.variants) {
        view = createVotingAdminView();
      } else {
        view = createVotingView(data);
      }
    }
    if (view) {
      container.html(view);
    }
  }

  function showErrorView(jXHR) {
    container.html(noVotingTemplate);
  }

  function getVotingResults() {
    var data = {
      streamId: streamId
    };
    $.ajax({
      url: votingUrl,
      type: 'GET',
      data: data,
      success: function(data){
        showAppropriateView(data);
      },
      error: function(jXHR) {
        showErrorView(jXHR);
      }
    });
  }

  function saveVoting(data, options) {
    data.type = 'variants';
    data.streamId = streamId;
    $.ajax({
      url: votingUrl,
      type: 'POST',
      data: data,
      success: options.success,
      error: options.error
    });
  }

  function deleteVoting() {
    var data = {
      streamId: streamId
    };
    $.ajax({
      url: votingUrl,
      type: 'DELETE',
      data: data,
      success: function(data){
        showAppropriateView(data);
      },
      error: function(jXHR) {
        showErrorView(jXHR);
      }
    });
  }

  function createVotingAdminView() {
    var votingAdminViewTemplate = $.parseHTML(voteAdminTemplate);
    var variantTemplate = $('.variant-template', votingAdminViewTemplate).detach();
    var variantsHolder = $('.variants', votingAdminViewTemplate);
    $('.add-variant', votingAdminViewTemplate).click(function () {
      var maxVariantCount = 5;
      if (variantCount <= maxVariantCount) {
        console.log(variantCount);
        $(variantsHolder).append(variantTemplate.clone());
        variantCount++;
      }
    });
    $('.save-voting', votingAdminViewTemplate).click(function (event) {
      event.preventDefault();
      var data = prepareDataForVoting($('.b-stream__voting-admin-form'));
      saveVoting(data, {
        success: function(data) {
          showAppropriateView(data);
        },
        error: function() { /* TODO Handle callback. */}
      });
    });
    return votingAdminViewTemplate;
  }

  function vote(id, options) {
    var data = {
      streamId: streamId,
      id: id,
      type: 'variant'
    };
    $.ajax({
      url: votingUrl,
      type: 'POST',
      data: data,
      success: options.success,
      error: options.error
    });
  }

  function init(streamId) {
    container = $('.b-stream__voting-holder');
    voteResultsTemplate = $('#voteResultsTemplate').html();
    voteTemplate = $('#voteTemplate').html();
    voteAdminTemplate = $('#voteAdminTemplate').html();
    noVotingTemplate = $('#noVotingTemplate').html();

    getVotingResults();
  }

  global.initStreamVoting = init;
}(window));