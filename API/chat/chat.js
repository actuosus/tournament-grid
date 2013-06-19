$(document).ready(function(){
					WEB_SOCKET_SWF_LOCATION = "http://www.virtuspro.org/API/chat/WebSocketMain.swf";
					var default_channel = 0;
					var ws;
					
					function getCookie(name) {
						var cookie = " " + document.cookie;
						var search = " " + name + "=";
						var setStr = null;
						var offset = 0;
						var end = 0;
						if (cookie.length > 0) {
							offset = cookie.indexOf(search);
							if (offset != -1) {
								offset += search.length;
								end = cookie.indexOf(";", offset)
								if (end == -1) {
									end = cookie.length;
								}
								setStr = unescape(cookie.substring(offset, end));
							}
						}
						return(setStr);
					}
				
					function getUrlVars2(){
						var vars = [], hash;
						var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
						for(var i = 0; i < hashes.length; i++){
							hash = hashes[i].split('=');
							vars.push(hash[0]);
							vars[hash[0]] = hash[1];
						}
						return vars;
					}
				
					(function($) {
						$.fn.counted = function(options) {
							var settings = {
								count: 300
							};     
							options = $.extend(settings, options || {});
							return this.each(function() {       
								var $this = $(this);     
								var counter = $("#input-notice").html(options.count)
								$(this).keyup(function(e) {
									var count = options.count - $this.val().length;
									if (count >= 0) {
										counter.html(count);
									}
									else {
										$this.val($this.val().substr(0, options.count));
										counter.html(0);
									}
								});
							});
						};
					})
					(jQuery);
					$('#pac_text').counted({count: 250});
					
					$("span.user>a>b").live('click', function(e){
						e.preventDefault();
						txt = $("#pac_text").val()
						$("#pac_text").val($(this).html()+': ')
						return false;
					});
					
	<?
		$groups = $_SESSION["SESS_AUTH"]["GROUPS"];
		if (in_array(7,$groups)) {
			require_once($_SERVER["DOCUMENT_ROOT"]."/API/chat/admin.include.html");
		}
	?>				
					$("a.smiles").click(function(){
						msg = $("#pac_text").val()
						$("#pac_text").val(msg+$(this).attr('smile'));
						return false;
					});
					
					$.get("/API/chat/chat_json.php", function(data){
						$("#streamcode").html(data[0]['html']);
						$.each(data, function(i, v){
							$("#stream_nav").append('<div style="float:left;padding:8px"><a stream_id="'+v.room+'" class="stream_button"><img align="middle" src="'+v.icon+'" alt="'+v.anounce+'" title="'+v.anounce+'"></a></div>')
						});
						if(getUrlVars2()['channel'] > -1){
							var default_channel = getUrlVars2()['channel']
						}
						else{
							var default_channel = 0
						}
						$("#streamcode").html(data[default_channel]['html']);
						
						$("a.stream_button").click(function(){
							$("#streamcode").html(data[$(this).attr('stream_id')]['html']);
							$("#chat_area").html('');
							ws.send($.toJSON({'command':'join', 'data':$(this).attr('stream_id')}));
							
							return false;
						});
					}, "json");
								
					try{
						WebSocket.loadFlashPolicyFile("xmlsocket://www.virtuspro.org:33890/");
					}
					catch(err){}
					ws = new WebSocket("ws://www.virtuspro.org:33890/");
					
					ws.onopen = function(){
						// console.log('OPEN');
						ws.send($.toJSON({'command':'register', 'data':[$.cookie('PHPSESSID'), getUrlVars2()['channel']]}))
					};
					ws.onmessage = function(e){
						msg = $.parseJSON(e.data);
						console.log(msg[);
						switch(msg.command){
							case 'msg' : 
								if(msg['user_id']){
									$("#chat_area").prepend('<span class="user" user_id="'+msg['user_id']+'">'+msg['ts']+"\n"+'<a>'+msg['from']+'</a>'+"\n"+msg['data']+'</span><br/>');
								}
								else{
									$("#chat_area").prepend('<span class="user">'+msg['ts']+"\n"+'<a>'+msg['from']+'</a>'+"\n"+msg['data']+'</span><br/>');
								}
							break;
							case 'eval' : eval(msg.data);
							break;
						}				
					};
					ws.onclose = function(){
						$("#chat_area").prepend('<span class="user"><font size="5" color="red">Нет связи с чатом, попробуйте обновить страницу через некоторое время!</font></span><br/>');
					};
					
					$("#pac_form").submit(function(){
						if(ws.readyState == 1){
							msg = $("#pac_text").val();
							if(msg.length > 0){
								$("#pac_text").val('');
								ws.send($.toJSON({'command':'msg', 'data':msg}))
							}
						}
						else{
							$("#chat_area").prepend('<span class="user"><font size="5" color="red">Нет связи с чатом, попробуйте обновить страницу через некоторое время!</font></span><br/>');
						}
					return false;
				});
					
					
				});