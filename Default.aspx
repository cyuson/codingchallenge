<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebAPI.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Hacker News Best Stories</title>
</head>
<body>

    <div>
        <h2>Search by ID</h2>
        <input type="text" id="storyId" size="25" />
        <input type="button" value="Search" onclick="find();" />
        <p id="story" ></p>
    </div>

    <div>
        <h2>Hacker News Best Stories</h2>
        <ul id="stories" ></ul>
    </div>

    <script src=" http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.0.js"></script>
    <script>
        // api to get best stories
        var uri = 'https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty';
        $(document).ready(function () {
            // Send an AJAX request
            $.getJSON(uri)
                .done(function (data) {
                    // On success, 'data' contains an element with list of ids for the story, so loop through each story id
                    //console.log(JSON.stringify(data));
                    if (data.length > 0) {
                        $({ text: getStoryFromId(data) }).appendTo($('#stories'));
                    }
                });
        });

        function formatText(data) {
            if (!data.title) {
                return "No story was found with the given ID. Please enter another ID."
            }

            return data.title + ' - Written By: ' + data.by;
        }

        function getStoryFromId(data) {
            // Create uri for each story id
            for (var i = 0; i < data.length; i++) {
                var obj = data[i];
                var uri = 'https://hacker-news.firebaseio.com/v0/item/' + obj + '.json?print=pretty';

                $.getJSON(uri)
                .done(function (data) {
                    // On success, 'data' contains a list of best stories.
                    $('<li>', { text: formatText(data) }).appendTo($('#stories'));
                });
            }
        }

        //Seach by Id
        function find() {
            var id = $('#storyId').val();
            var uri = 'https://hacker-news.firebaseio.com/v0/item/' + id + '.json?print=pretty';
            var error = 'Please enter a valid ID.'

            $.getJSON(uri)
                .done(function (data) {
                    $('#story').text(formatText(data));
                })
                .fail(function (jqXHR, textStatus, err) {
                    $('#story').text('Error: ' + error);
                });
        }
    </script>
</body>
</html>
