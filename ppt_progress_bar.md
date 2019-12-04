# How to make a powerpoint progress bar

This script was originally written by Jose Gascon on [github](https://gist.github.com/PiiXiieeS/7181980), and was subsequently edited / customized for convenience by Mirza Elahi while at [UVA](http://people.virginia.edu/~me5vp/blog/2016/07/progressbar-in-powerpoint.html). I have edited Mirza's comments to reflect newer ppt versions.
- According to Mirza's post on the UVA website, this code is under the MIT license. 
  - *"You’re welcome to borrow / repurpose code and if you do, I’d appreciate attribution and a link back here and to the original article by Jose Gascon."*

## Instructions
How to insert:
- Make your slideshow.
  - You can add in the pbar before you're finished, but if you add any new slides after you've already added the pbar, you'll need to remove it and then add in again when you've fully finished.
- Go to View > Macros (older versions it's under Tools).
- Write a dummy macro name add click "create".
- This will open up a editor. Paste the below script and go back to the presentation. Your script is automatically saved, and you don't need to close the editor.
- Again go to View > Macros, now you will see two routines.
  - Select AddProgressBar and press "Run" to insert progress bar and total slide no.
  - Select RemoveProgressBar and press "Run" to remove all the objects inserted by AddProgressBar.
- You can edit the script by pressing Edit.

### Saving
When you close the script editor and close out of ppt, your script will not be saved unless it's saved specifically as a macros-file type or something. However, any progress bar you add in will still be there.
- what this means is realistically, only add in the progress bar at the end. If you end up needing to make a fix, you'll just need to redo the steps above for adding the script again.

For RGB color comparisons, [here](https://www.html.am/html-codes/color/color-scheme.cfm?rgbColor=255,255,255) is a helpful website.

## Script
```
' Author : Mirza Elahi
' Date : 07 Jul, 2016
Sub AddProgressBar()
    ' Parameters to set
    progressBarHeight = 3.5 ' height of the progress bar
    FillColor = RGB(251, 0, 6) ' Fill color of the progress bar
    LineColor = FillColor ' Line color of the progress bar
    BackgroundColor = RGB(255, 255, 255) ' background color of the progress bar
    fontColor = FillColor
    startingSlideNo = 1
    noFontSize = 13
    showSlideNo = True ' Set this to False if you dont want to show total slide no
    'Slider Making
    On Error Resume Next
        With ActivePresentation
            sHeight = .PageSetup.SlideHeight - progressBarHeight
            n = 0
            j = 0
            For i = 1 To .Slides.Count
                If .Slides(i).SlideShowTransition.Hidden Then j = j + 1
            Next i: 
            For i = startingSlideNo To .Slides.Count
                .Slides(i).Shapes("progressBar").Delete
                .Slides(i).Shapes("progressBarBackground").Delete
                .Slides(i).Shapes("pageNumber").Delete
                If .Slides(i).SlideShowTransition.Hidden = msoFalse Then
                    ' Background setting
                    ' Underscore used for continuation of line
                    Set sliderBack = .Slides(i).Shapes.AddShape( _
                                        msoShapeRectangle, 0, _
                                        sHeight, (.Slides.Count - j) _
                                        * .PageSetup.SlideWidth _
                                        / (.Slides.Count - j), _
                                        progressBarHeight)
                    With sliderBack
                        .Fill.ForeColor.RGB = BackgroundColor
                        .Line.ForeColor.RGB = BackgroundColor
                        .Name = "progressBarBackground"
                        End With
                    ' Main Slider setting
                    Set slider = .Slides(i).Shapes.AddShape( _
                                        msoShapeRectangle, 0, _
                                        sHeight, (i - n) * _
                                        .PageSetup.SlideWidth _
                                        / (.Slides.Count - j), _
                                        progressBarHeight)
                    With slider
                        ' enable this line to set theme color
                        '.Fill.ForeColor.RGB = ActivePresentation.SlideMaster.ColorScheme.Colors( _
                        ppFill).RGB
                        .Fill.ForeColor.RGB = FillColor
                        .Line.ForeColor.RGB = LineColor
                        .Name = "progressBar"
                    End With
                    Set pageNumber = .Slides(i).Shapes.AddTextbox( _
                                        msoTextOrientationHorizontal, _
                                        ((.Slides.Count - j) * _
                                        .PageSetup.SlideWidth / _
                                        (.Slides.Count - j)) - 50, _
                                        .PageSetup.SlideHeight - 23, 100, 10)
                    ' Slide No
                    If showSlideNo = True Then
                        With pageNumber
                            .TextFrame.TextRange.Text = Str(i - n) & "/" & _
                                    Str(ActivePresentation.Slides.Count - j)
                            With .TextFrame.TextRange.Font
                                .Bold = msoFalse
                                .Size = noFontSize
                                .Color = fontColor
                            End With
                            .Name = "pageNumber"
                        End With
                    End If

                Else
                    n = n + 1
                End If
            Next i:
        End With
End Sub

Sub RemoveProgressBar()
    On Error Resume Next
    With ActivePresentation
        For i = 1 To .Slides.Count
            .Slides(i).Shapes("progressBar").Delete
            .Slides(i).Shapes("progressBarBackground").Delete
            .Slides(i).Shapes("pageNumber").Delete
        Next i:
    End With
End Sub
```
