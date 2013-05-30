###
 * menu_item
 * @author: actuosus
 * Date: 29/05/2013
 * Time: 22:27
###

define ->
  App.MenuItem = Em.Object.extend
    target: null
    action: null
    isEnabled: yes
    isHidden: no
#    isHiddenOrHasHiddenAncestor: no
    isHighlighted: no
    isSeparatorItem: no
    keyEquivalent: null
    keyEquivalentModifierMask: null
    tag: 0
    title: null
    attributedTitle: null

    image: null
    mixedStateImage: null
    offStateImage: null
    onStateImage: null

    indentationLevel: 0

    submenu: null

    state: 0

    toolTip: null
    userKeyEquivalent: null

#    view: null

    isAlternate: (->).property()
#    isAlternate: (->).property()

    # Relations
    menu: null
    parentItem: null

    representedObject: null