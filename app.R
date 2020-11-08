library(shiny)
library(shinycssloaders)
library(tidyverse)
library(plotly)
library(DT)
library(shinythemes)
library(markdown)


## FRONT END ####
# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Theme 
  theme = shinytheme("united"),
  
  ## FRONT END - main ####
   # Application title
  navbarPage("SSMIBiG",
   # Input page
  tabPanel("Application",
      sidebarLayout(    
        sidebarPanel(
          numericInput(inputId ="pubchem_id",label = "PubChem id of the substructure:", value = "1049"),
          actionButton(inputId = "search", label = "Search")
        ),
   # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(type = "tabs",
                    tabPanel("Structure",DT::dataTableOutput("structure") %>% withSpinner(color="#0dc5c1") ),
                    tabPanel("Biosynthetic class",plotlyOutput("biosyn_plot") %>% withSpinner(color="#0dc5c1") ),
                    tabPanel("Table",dataTableOutput("hit_table") %>% withSpinner(color="#0dc5c1") )
                  )
          )
      )
  ),
  
  ## FRONT END - Documentation ####
  tabPanel("Documentation",
           fluidRow(column(6,
                    includeMarkdown("README.md")
                    ))
          )
  )
)  


## BACKEND ####
# Define server logic required 
server <- function(input, output) {
  # load mibig database
  mibig = data.table::fread(sprintf("https://docs.google.com/uc?id=%s&export=download", "1VaajnqDA0UM-mh7Z9lBwUJ2qRvP3q_61"))
  
  
  # On click - Get substrcutures and match with mibig
  onClick = eventReactive(input$search, {
    substructures = mibig[mibig$pchids %in% 
            data.table::fread(paste0("https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/fastsubstructure/cid/",
                                     input$pubchem_id,"/cids/TXT?StripHydrogen=true&fullsearch=true"),
                              header = F)$V1,]
    return(substructures)  
                                        })

  output$hit_table = renderDataTable(onClick())
  
  #On click - plot biosynthetic class
  
  onClick1 = eventReactive(input$search, {
  plot = ggplot(data = onClick()) +
    geom_bar(mapping = aes(x=fct_infreq(biosyn_class)),
             color = "darkgreen", fill = "white" ) +
    labs(x = "Biosynthetic class", y = "Number of BGC") +
    theme_classic() +
    coord_flip() 
  plot = ggplotly(plot)
  return(plot)
  })
  
  output$biosyn_plot = renderPlotly(onClick1())
  
  
 # On click - get structures
  onClickStruc = eventReactive(input$search, {
                structure_table = data.frame(
                              Compound = onClick() %>% .$compounds.compound,
                              Structure = onClick() %>% select(Structure = pchids) %>% lapply(.,function(id) {
                                          sprintf('<img src="https://pubchem.ncbi.nlm.nih.gov/image/imgsrv.fcgi?cid=%s&t=l" height="200" width=200></img>', id
                                                                                              )})
                                            )
                          return(structure_table)}
                              )
  
  output$structure = renderDataTable({DT::datatable(onClickStruc(),escape = FALSE)}) # escape false to interpret HTML image
  
 # output$readme_md <- renderUI({includeMarkdown("README.md")})
}

## RUN ####
# Run the application 
shinyApp(ui = ui, server = server)

