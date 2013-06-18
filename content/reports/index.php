<?
require($_SERVER["DOCUMENT_ROOT"]."/bitrix/header.php");
$APPLICATION->SetTitle("Reports");
?>
    <div id="content"></div>
    <script type="text/javascript">
        window.grid = {
            reportId: 33664,
            config: {
                rootElement: '#content'
            }
        };
    </script>
    <link rel="stylesheet" href="http://virtus-pro.herokuapp.com//bundle/stylesheets/app.css" />
    <script data-main="http://zbookpro.actuosus.com:3000/app/main.js" src="http://virtus-pro.herokuapp.com//vendor/scripts/require.min.js"></script>
<?require($_SERVER["DOCUMENT_ROOT"]."/bitrix/footer.php");?>