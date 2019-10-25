#' Download Sentinel 2 dataset from google cloud.
#'
#' This function requires Google Cloud Storage SDK, you can download and install this SDK
#' from google cloud website.
#'
#' Once it started, press ctrl+c in the command line can stop it.
#'
#' If there's any bug, please let me know.
#'
#' Author: Jacory
#'
#' @param tilename what tile do you want to download
#' @param folder local folder used to store downloaded files
#' @param L2Flag indicate to download L2A product or L1C product (default)
#' @param regExp regular expression, with which you can speicify which files you want. For example,
#' regExp <- "S2\\D_MSIL\\d\\D_201([6]|[8][0][0-9]).*.SAFE/$" means you want data from 2016 and before 2018 before October.
#' @keywords sentinel
#' @export
#' @examples
#' DownloadSentinel2("17SNA", "D:/", L2Flag = TRUE, rexExp = "S2\\D_MSIL\\d\\D_201([6]|[8][0][0-9]).*.SAFE/$")
DownloadSentinel2 <- function(tilename, folder, L2Flag = FALSE, regExp = NULL) {
    gcUrl <- ifelse(L2Flag == TRUE, file.path("gs://gcp-public-data-sentinel-2/L2/tiles", substr(tilename, 1, 2),
                                        substr(tilename, 3, 3), substr(tilename, 4, 5)),
                                    file.path("gs://gcp-public-data-sentinel-2/tiles", substr(tilename, 1, 2),
                                        substr(tilename, 3, 3), substr(tilename, 4, 5)))
    com <- paste("gsutil ls", gcUrl)
    fileList <- system(com, intern = TRUE) # View(fileList)
    # create destination folder
    destDir <- folder
    if (dir.exists(file.path(destDir, tilename)) == FALSE) dir.create(file.path(destDir, tilename))

    # regular expression filter
    if (!is.null(regExp)) fileList <- grep(regExp, fileList, value = TRUE)

    # started downloading
    for (i in 1:length(fileList)) {
        temp <- unlist(strsplit(fileList[i], "/"))
        dirname <- temp[length(temp)]
        if (dir.exists(file.path(destDir, tilename, dirname)) == FALSE) {
            system(paste("gsutil -m cp -r", fileList[i], file.path(destDir, tilename, ".")))
        }
    }
}
