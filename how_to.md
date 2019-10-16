# How to add functions to this library

## Adding functions to this package
This how-to comes from https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/. You can go through that yourself if you wish, or you can follow along here.

### Example
Let's say you need a distraction. This is a real-world example.

First, it's helpful to be using the cgaR.Rproj. Otherwise, you need to setwd("./cgaR").

Create a new .R file containing only your new function and save in the "R" folder of this repo.
```r
dawww <- function(choice=c("spring", "summer", "fall", "winter", "smolbabe", "doggo", "surprise")){

  # This is where all the pics are
  sites <- c('https://pixabay.com/photos/search/baby%20animals/',
             'https://pixabay.com/photos/search/spring/',
             'https://pixabay.com/photos/search/summer/',
             'https://pixabay.com/photos/search/fall/',
             'https://pixabay.com/photos/search/winter/',
             'https://pixabay.com/photos/search/puppies/',
             'https://pixabay.com/photos/search/flying/',
             'https://pixabay.com/photos/search/safari/',
             'https://pixabay.com/photos/search/mountain/')

  if(choice == "smolbabe"){
    pic <- html_session(sites[[1]])
  } else if(choice == "spring") {
    pic <- html_session(sites[[2]])
  } else if(choice == "summer") {
    pic <- html_session(sites[[3]])
  } else if(choice == "fall") {
    pic <- html_session(sites[[4]])
  } else if(choice == "winter") {
    pic <- html_session(sites[[5]])
  } else if(choice == "doggo"){
    pic <- html_session(sites[[6]])
  } else if(choice == "surprise") {
    pic <- html_session(sample(c(sites[[7]], sites[[8]], sites[[9]]), 1))
  }

  ##the language below is used for smolbabe but otherwise the functionality is the same

  # Play hide and seek with the bebbes
  hiddenbebbes <- html_nodes(pic, "img")

  # Found them!
  foundbebbes <- html_attr(hiddenbebbes,"src")
  foundbebbes <- foundbebbes[-grep("static", foundbebbes)]

  # Wait... We are missing some
  extrasneakybebbes <- html_attr(hiddenbebbes,"data-lazy-srcset")
  extrasneakybebbes <- str_split(na.omit(str_remove_all(extrasneakybebbes,"[1-9]x")),", ")
  extrasneakybebbes <- unlist(extrasneakybebbes)

  # Get em all together for a picture
  awww <- c(foundbebbes, extrasneakybebbes)

  # Take them home (ok maybe not all at once)
  temporary_file_location <- paste0(tempdir(), "/baby_animals.png")

  download.file(awww[sample(1:length(awww),1)],
                temporary_file_location, mode = "wb")

  # Bring the baby to R
  smolbabe <- load.image(temporary_file_location)

  # Display the smolbabe
  plot(smolbabe, yaxt = 'n', axes = FALSE)
}
```
Then add the documentation lines like this. You don't need to save.
```r
#' dawww
#'
#' Your daily dose of distraction. Make a choice, see the results, smile.
#'
#' This function is an extension of the original pupR package from https://github.com/melissanjohnson/pupR. All pictures are taken from pixabay.com.
#'
#' @param choice From the list above, you may only choose one.
#'
#' @return A photo of your choice is downloaded and displayed in the plot window.
#'
#' @importFrom rvest html_session html_nodes html_attr
#' @importFrom imager load.image
#' @importFrom stringr str_split str_remove_all
#'
#' @export
#' @examples
#' dawww("smolbabe") #get 1 picture of a smolbabe
#' replicate(5, "doggo") #get 5 pictures of doggos
 
*rest of function here*
```

Now in the console, run the following. This will automatically save and add the documentation to the package.
```r
library(dev_tools)
library(roxygen2)
document()
```

That's it! To install the new version of the package, use `install_github("mcgregorian1/cgaR")`.
