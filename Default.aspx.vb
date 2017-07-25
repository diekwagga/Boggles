
Imports System
Imports System.Collections.Generic
Imports System.IO
Imports System.Diagnostics
Imports System.Globalization


Enum WordType As Byte
    FullWord
    PartialWord
    FullWordAndPartialWord
End Enum

Partial Class _Default
    Inherits System.Web.UI.Page

    Shared stopWatch As Stopwatch
    Shared resultCount As Integer
    Shared _words As New Dictionary(Of String, WordType)(400000)
    Shared _found As New Dictionary(Of String, Boolean)()
    Shared results As StringBuilder
    Const _minLength As Integer = 3

    Private Sub _Default_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            If (_words.Count < 1) Then
                LoadDictionary()
            End If
        Else
            Dim parameter = Me.Request("__EVENTARGUMENT")
            If Not parameter Is Nothing Then
                Dim stringSeparators() As String = {","}
                Dim result() As String
                result = parameter.Split(stringSeparators,
                              StringSplitOptions.RemoveEmptyEntries)
                If result.Length > 0 Then
                    results = New StringBuilder
                    _found = New Dictionary(Of String, Boolean)
                    resultCount = 0

                    Dim started As String = DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss.fff", CultureInfo.InvariantCulture)
                    stopWatch = New Stopwatch()
                    stopWatch.Start()

                    SolvePuzzle(result)


                    Dim ended As String = DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss.fff", CultureInfo.InvariantCulture)
                    stopWatch.Stop()
                    Dim ts As TimeSpan = stopWatch.Elapsed


                    ClientScript.RegisterStartupScript(Me.GetType(), "DisplayResults", "displayResults('" + results.ToString() + "','" + resultCount.ToString() + "', '" + started.ToString() + "', '" + ended.ToString() + "', '" + ts.TotalSeconds.ToString() + "')", True)
                    udPanel.Update()
                End If
            End If
        End If
    End Sub

    Private Sub LoadDictionary()
        Dim path As New System.IO.DirectoryInfo(HttpContext.Current.Server.MapPath("~"))
        Dim fileDir As String = path.FullName + "\wordlist.txt"
        Using reader As New StreamReader(fileDir)
            While True
                Dim line As String = reader.ReadLine()
                If line Is Nothing Then
                    Exit While
                End If
                If line.Length >= _minLength Then
                    For i As Integer = 1 To line.Length
                        Dim substring As String = line.Substring(0, i)
                        Dim value As WordType
                        If _words.TryGetValue(substring, value) Then
                            If i = line.Length Then
                                If value = WordType.PartialWord Then
                                    _words(substring) = WordType.FullWordAndPartialWord
                                End If
                            Else
                                If value = WordType.FullWord Then
                                    _words(substring) = WordType.FullWordAndPartialWord
                                End If
                            End If
                        Else
                            If i = line.Length Then
                                _words.Add(substring, WordType.FullWord)
                            Else
                                _words.Add(substring, WordType.PartialWord)
                            End If
                        End If
                    Next
                End If
            End While
        End Using
    End Sub

    Private Sub SolvePuzzle(ByVal result() As String)
        Dim height As Integer = result.Length
        Dim width As Integer = result(0).Length
        Dim array As Char(,) = New Char(height - 1, width - 1) {}
        For i As Integer = 0 To width - 1
            For a As Integer = 0 To height - 1
                array(a, i) = result(a)(i)
            Next
        Next

        Dim covered As Boolean(,) = New Boolean(height - 1, width - 1) {}


        For i As Integer = 0 To width - 1
            For a As Integer = 0 To height - 1
                Search(array, i, a, width, height, "",
                    covered)
            Next
        Next
    End Sub

    Private Shared Sub Search(array As Char(,), i As Integer, a As Integer, width As Integer, height As Integer, build As String,
    covered As Boolean(,))
        If i >= width OrElse i < 0 OrElse a >= height OrElse a < 0 Then
            Return
        End If
        If covered(a, i) Then
            Return
        End If
        Dim letter As Char = array(a, i)
        Dim pass As String = build & letter
        Dim value As WordType
        If _words.TryGetValue(pass, value) Then
            If value = WordType.FullWord OrElse value = WordType.FullWordAndPartialWord Then
                If Not _found.ContainsKey(pass) Then
                    results.Append(pass.ToLower() & ",")
                    resultCount += 1
                    _found.Add(pass, True)
                End If
            End If
            If value = WordType.PartialWord OrElse value = WordType.FullWordAndPartialWord Then
                Dim cov As Boolean(,) = New Boolean(height - 1, width - 1) {}
                For i2 As Integer = 0 To width - 1
                    For a2 As Integer = 0 To height - 1
                        cov(a2, i2) = covered(a2, i2)
                    Next
                Next
                cov(a, i) = True

                Search(array, i + 1, a, width, height, pass,
                    cov)
                Search(array, i, a + 1, width, height, pass,
                    cov)
                Search(array, i + 1, a + 1, width, height, pass,
                    cov)
                Search(array, i - 1, a, width, height, pass,
                    cov)
                Search(array, i, a - 1, width, height, pass,
                    cov)
                Search(array, i - 1, a - 1, width, height, pass,
                    cov)
                Search(array, i - 1, a + 1, width, height, pass,
                    cov)
                Search(array, i + 1, a - 1, width, height, pass,
                    cov)
            End If
        End If
    End Sub

End Class
