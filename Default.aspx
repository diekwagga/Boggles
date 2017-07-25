<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script src="js/jquery-3.2.1.js"></script>
    <title>Boggles!</title>
    <script type="text/javascript">
        $(document).ready(function () {
            $('.button').click(function () {
                var buttonText = $(this).html();
                if (buttonText.indexOf('4x4') >= 0) {
                    generateGrid(4, true);
                } else if (buttonText.indexOf('5x5') >= 0) {
                    generateGrid(5, true);
                } else if (buttonText.indexOf('6x6') >= 0) {
                    generateGrid(6, true);
                } else if (buttonText.indexOf('SSP') >= 0) {
                    generateGrid(4, false);
                } else if (buttonText.indexOf('Solve') >= 0) {
                    solvePuzzle();
                }
            });
        });

        function generateGrid(size, isRandom) {
            $('.results').hide();
            $('#btnSolve').hide();
            $('.grid').hide();
            $('.grid').empty();
            var content = '<table cellspacing="0" cellpadding="0">';
            if (isRandom) {
                for (tr = 0; tr < size; tr++) {
                    content += '<tr>';
                    for (td = 0; td < size; td++) {
                        content += '<td>' + randomLetter() + '</td>';
                    }
                    content += '</tr>';
                }
            }
            else {
                content += '<tr>';
                content += '<td>O</td><td>L</td><td>G</td><td>U</td>';
                content += '</tr>';
                content += '<tr>';
                content += '<td>N</td><td>Y</td><td>O</td><td>D</td>';
                content += '</tr>';
                content += '<tr>';
                content += '<td>A</td><td>U</td><td>T</td><td>S</td>';
                content += '</tr>';
                content += '<tr>';
                content += '<td>H</td><td>I</td><td>A</td><td>D</td>';
                content += '</tr>';
            }
            content += '</table>';
            $('.grid').append(content);
            $('.grid').fadeIn();
            $('#btnSolve').fadeIn();
        }

        function randomLetter() {
            var text = "";
            var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            text = possible.charAt(Math.floor(Math.random() * possible.length));
            return text;
        }

        function solvePuzzle() {
            var puzzleValues = "";
            $('.grid table tr').each(function (i, row) {
                var rowValues = "";
                var $row = $(row),
                    $cells = $row.find('td');

                $cells.each(function () {
                    var val = $(this).html();
                    if (val != null) {
                        rowValues += val;
                    }
                });
                puzzleValues += rowValues + ",";
            });
            puzzleValues = puzzleValues.slice(0, -1);
            __doPostBack('btnSolve', puzzleValues);
        }

        function displayResults(results, resultCount, startTime, endTime, elapsedSeconds) {
            $('#btnSolve').hide();
            results = results.slice(0, -1);
            results = results.replace(/\,/g, ', ');
            $('.results').append('<h2>' + resultCount + ' Words Found</h2>');
            $('.results').append(results);
            $('.results').append('<p><strong>Start time:</strong> ' + startTime + '</p>');
            $('.results').append('<p><strong>End time:</strong> ' + endTime + '</p>');
            $('.results').append('<p><strong>Total time elapsed:</strong> ' + elapsedSeconds + ' seconds</p>');
            $('.results').slideDown();
        }

    </script>
    <style type="text/css">
        body, form {
            width: 100%;
            height: 100%;
            text-align: center;
            background-color: #dfdae0;
            font-family: Helvetica;
        }

        div {
            display: inline-block;
        }

        .main {
            border: 2px solid #c2c1cf;
            border-radius: 100px;
            background-color: #fff;
            box-shadow: 5px 5px 15px #c2c1cf;
            width: 50%;
            min-height: 500px;
            vertical-align: middle;
            margin-top: 5%;
            padding-bottom: 35px;
        }

        h1 {
            font-size: 48px;
            font-family: Courier;
            font-weight: bold;
            color: #000;
        }

        h1 {
            font-family: Courier;
            font-weight: bold;
            color: #000;
        }

        .button {
            padding: 10px 15px;
            margin: 0px 5px;
            background-color: #7b8d97;
            border: 2px solid #000;
            border-radius: 50px;
            color: #fff;
            font-family: Lucida Console;
        }

            .button:hover {
                cursor: pointer;
                background-color: #8cadbe;
            }

        .grid {
            display: none;
            clear: both;
            width: 100%;
        }

            .grid table {
                margin: 40px auto;
                border-collapse: collapse;
            }

                .grid table td {
                    border: 1px solid #c2c1cf;
                    border-collapse: collapse;
                    padding: 10px 15px;
                    font-family: Courier;
                    font-weight: bold;
                    font-size: 20px;
                }

        #btnSolve {
            clear: both;
            display: none;
        }

        .results {
            display: none;
            padding: 20px;
            width: 80%;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="scManager" runat="server"></asp:ScriptManager>
        <div class="main">
            <h1>Boggles!
            </h1>
            <div class="button">4x4 Grid</div>
            <div class="button">5x5 Grid</div>
            <div class="button">6x6 Grid</div>
            <div class="button">SSP Challenge</div>
            <div class="grid"></div>
            <div class="results"></div>
            <div id="btnSolve" class="button">Solve</div>
        </div>

        <asp:UpdatePanel ID="udPanel" runat="server" UpdateMode="Conditional" Visible="false"></asp:UpdatePanel>
    </form>
</body>
</html>
