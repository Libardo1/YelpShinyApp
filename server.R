library(shiny)
library(XML)
library(ggmap)
library(plyr)
library(shinyIncubator)

shinyServer(function(input, output, session) {
        
        output$map <- renderPlot({
                
                withProgress(session, min = 1, max = 15, {
                        setProgress(message = 'Generating hotspots', 
                                    detail = 'This may take a while...')
                
                        addresses <- data.frame()
                j = 0
                term <- input$term
                city <- input$city
                setProgress(value = 5)                        
                for(i in 1:1){
                        url <- "http://www.yelp.com/search?find_desc=hiking&find_loc=Orange+County%2C+CA&start="
                        url <- gsub("hiking", term, url)
                        url <- gsub("Orange+County", city, url, fixed = TRUE)
                        url <- paste0(url, j)
                        doc <- htmlTreeParse(url, useInternalNodes = TRUE)
                        data <- xpathSApply(doc,'//address', xmlValue)
                        data <- gsub("\n", "", data)
                        data <- gsub("([[:lower:]])([[:upper:]])", "\\1 \\2", data)
                        data <- gsub("^\\s+|\\s+$", "", data)
                        data <- gsub(",", "", data)
                        filename  <-  paste0(i, ".csv")
                        write.csv(data, file = filename)
                        text <- read.csv(filename)
                        addresses <- rbind(addresses, text)
                        j = j + 10       
                }
                setProgress(value = 10)
                yelplocations <- ldply(as.character(addresses$x), function(x) geocode(x))
                maplocation <- input$city
                maplocation <- gsub("[[:punct:]]", " ", maplocation)
                map <- qmap(maplocation, color = "bw", zoom = 10)
                
                setProgress(value = 15)
                
                map + stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
                               bins = 15, geom = "polygon",
                               data = yelplocations) +
                scale_fill_gradient(low = "blue", high = "red") +
                scale_alpha(range = c(0.00, 0.25), guide = FALSE) +
                theme(legend.position = "none", 
                      axis.title = element_blank(), text = element_text(size = 12))
                })
        })
})