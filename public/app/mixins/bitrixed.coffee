###
 * bitrixed
 * @author: actuosus
 * Date: 16/06/2013
 * Time: 18:51
###

define ->
  App.Bitrixed = Em.Mixin.create
    didInsertElement: ->
      @_super()
      if window.BX
        BX.ready( -> (
          new BX.CPageOpener({
            'parent':'bx_incl_area_7',
            'id':'comp_7',
            'component_id':'page_edit_control',
            'menu':[{
              'ICONCLASS':'bx-context-toolbar-edit-icon',
              'TITLE':'Редактировать страницу в визуальном редакторе',
              'TEXT':'Изменить страницу в редакторе',
              'ONCLICK':'(new BX.CAdminDialog({\'content_url\':\'/bitrix/admin/public_file_edit.php?bxpublic=Y&lang=ru&path=%2Fbase%2Fteams%2Fdetail.php&site=s1&back_url=%2Fbase%2Fteams%2Fteam-cursive%2Fteam-cursive-cs-go%2F&templateID=VIRTUS.PRO.TPL.MAIN\',\'width\':\'770\',\'height\':\'470\'})).Show()','DEFAULT':true,'MENU':[{'TEXT':'Изменить страницу как HTML','TITLE':'Редактировать страницу в режиме HTML','ICON':'panel-edit-text','ACTION':'javascript:(new BX.CAdminDialog({\'content_url\':\'/bitrix/admin/public_file_edit.php?bxpublic=Y&lang=ru&noeditor=Y&path=%2Fbase%2Fteams%2Fdetail.php&site=s1&back_url=%2Fbase%2Fteams%2Fteam-cursive%2Fteam-cursive-cs-go%2F\',\'width\':\'770\',\'height\':\'470\'})).Show()'},{'TEXT':'Изменить свойства страницы','TITLE':'Изменить заголовок и другие свойства страницы','ICON':'panel-file-props','ACTION':'javascript:(new BX.CDialog({\'content_url\':\'/bitrix/admin/public_file_property.php?lang=ru&site=s1&path=%2Fbase%2Fteams%2Fdetail.php&back_url=%2Fbase%2Fteams%2Fteam-cursive%2Fteam-cursive-cs-go%2F\',\'width\':\'\',\'height\':\'\',\'min_width\':\'450\',\'min_height\':\'250\'})).Show()'},{'SEPARATOR':true},{'TEXT':'Скрыть эту панель','TITLE':'Не отображать панель редактирования страницы','ACTION':'javascript:if (confirm(\'Скрыть панель редактирования страницы? Eё можно вернуть на экран в настройках интерфейса.\')) window.PAGE_EDIT_CONTROL.Remove()'
              }]
            }]
          })
        ).Show())
        BX.admin.setComponentBorder(@get('elementId')) if window.BX and BX.admin