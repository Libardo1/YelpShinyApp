library(shiny)
library(XML)
library(ggmap)
library(plyr)
library(shinyIncubator)

shinyUI(
        
        fluidPage(    
                
                titlePanel("Yelp Hotspot Mapper"),
                
                sidebarLayout(      

                        sidebarPanel(
                                textInput("term", "Enter a term:", value = "tacos"),
                                
                                selectInput("city", "Choose a city:", 
                                            choices=c("Orange County" = "Orange+County", "Los Angeles" = "Los+Angeles",
                                                      "San Francisco"="San+Francisco", "San Diego" = "San+Diego")),
                                
                                submitButton('Update Map')
                        ),

                        mainPanel(
                                plotOutput("map")  
                        )
                        
                )
        )
)