library (shinythemes)
library (shinydashboard)
library (shinyWidgets)
library (shinyjs)
library (shinyEffects)
library (shinyBS)
library (shinyjqui)



shinyUI(
  navbarPage("",
  theme=shinytheme("flatly"),
    tabPanel (h3("Struvite stones prevention diet for dogs"),
  
       
  useShinyjs(),
  useShinydashboard(),
 
  setShadow(class= "box"),
  setZoom(id= "sliderInput"),

  tags$head(
    tags$style(
      HTML(".shiny-notification {
           position:fixed;
           top: calc(60%);
           left: calc(25%);
           }
           "
      )
      )),
  

  
	sidebarLayout(
	  sidebarPanel (
		width=3,
		
		h4("Weight of the dog:"),
		wellPanel(
		numericInput("kg", h5("Gewicht des Hundes(kg):"), value=10, min = 1, max = 100, width= "30%", label = tags$div(HTML('<i class="fas fa-paw" style = "color:black;"></i>  (kg) ')))
		)
		,
	  
		h4("Selection of feed components:"),
		wellPanel(
		 
		selectInput("hauptkomp", h5("Please select the main component of the diet:",bsButton("help1", label = "", icon = icon("question"),
		                                                                                   size = "extra-small")), 
		selected = "", choices= list("",
		"Protein-rich feed" = c("Chicken leg"="Keule", "Prime rib, cow" = "Rippe", "Cheese 40% fat"="Kaese", "Quark, low fat" ="Quark"), 
		 "carbohydrate feed"= c("Rice, polished"="Reis", "Potato, cooked"="Kartoffeln", "Oats"="Haferflocken" )), selectize=T , width= 200
		),
		
		bsTooltip("help1", "The amount of the main component is automatically calculated to meet the dogs energy need (Energy maintenance requierement: 0,4 MJ ME/kg body mass^0,75)",
		          "right")
	)
	,
		wellPanel(
		  #tags$head(tags$style(type = "text/css", '.well{width: 220px}')) , 
		h5("Select out of following feed components:",bsButton("help2", label = "", icon = icon("question"),
		                                                                                     size = "extra-small")),
		bsTooltip(id = "help2", 
		         "Determine the percentage of the additional feed components within the diet. The selected amount will be substracted from the main component.",
		          placement = "right", 
		          trigger = "hover" 
		          )
		          
		,
		tags$br(),
		dropdownButton(
		  inputId = "protein",
		  label = "Protein-rich feed",
		  icon= icon ("plus"),
		  #icon = icon("plus", lib = "glyphicon"),
		  status = "primary",
		  circle = F,
		  width= 150,
		  tooltip = tooltipOptions(title = "proteins should make up 35-45% of the diet"),
		  margin= "10px",
		  sliderInput ("Keule", "Chicken leg (%)", 0, 100, 0),
		  sliderInput ("Rippe", "Prime rib cow(%)", 0,100,0),
		  sliderInput ("Kaese", "Cheese 40% fat (%)", 0,100,0),
		  sliderInput ("Quark", "Quark, low fat(%)", 0,100,0)
		  
		),
		
		tags$br(),
		dropdownButton(
		  inputId = "carbo",
		  label = "Carbohydrate- richt feed",
		  icon = icon("grain", lib = "glyphicon"),
		  #icon = icon("seedling"),
		  status = "primary",
		  circle = F,
		  width=10,
		  tooltip = tooltipOptions(title = "carbohydrates should make up 45-55% of the diet"),
		  sliderInput ("Reis", "Rice, polished (%)", 0, 100,0),
		  sliderInput ("Kartoffeln", "Potato, cooked (%)", 0, 100,0),
		  sliderInput ("Haferflocken", "Oats (%)", 0, 100,0)#,
		 # sliderInput ("Karotten", "Carrots (%)", 0, 100,0)
		  
		),
	
		tags$br(),
		dropdownButton(
		  inputId = "mineral",
		  label = "mineral-rich feed",
		  
		  icon = icon("bone"),
		  status = "primary",
		  tooltip = tooltipOptions(title = "By adding a vitaminized mineral feed, the meal becomes a complete feed"),
		  circle = F,
		  numericInput ("Salz", "Salt (g)", value=0, max=10, min= 0, step= 1),
		  numericInput ("Eischale", "Eggshell (g)", value=0, max=100, min=0, step= 1 ),
		  numericInput("Diaet", "Dietary supplement feed to treat struvite bladder stones (g):", 0, min=0, max=100, step= 1)
		 
		),
		tags$br(),
		tags$br(),
		tags$br(),
		
		tags$img (src="DigiStep.png")
		
		)
	
	),
		
	mainPanel(
		   
			  
			  
			  tabBox(title= "", id="plotBox",
			         tabPanel (h4("Mineral and nutrition supply"), br(),plotOutput("plot")),
			         tabPanel (tagList (shiny::icon("info")),  br(), textOutput("title1"),br(), textOutput ("segmentinfo"),
			                  tags$img (src="Bedarf.png"), br(),br(), textOutput("title2"),
			                   
			                  textOutput("geominfo"), br(), tags$img (src="Pro.png")
			         )          
			         ),
			  
		   fluidRow( 
		    (box (h5("Feed amount:"),tableOutput("table"), textOutput("energie"), width=4, closable=T, collapsible = T)),
			  tags$br(),
			  tags$br(),
			  tags$br(),
			  tags$br(),
			  br(),
			  #infoBoxOutput ("ibox", width=4),
			  tabBox(title="", id="pHBox",width=4, 
			         tabPanel (h5("Reached urine pH-level:"), textOutput("textpH"), br(), textOutput("textpH1")),
			         tabPanel (tagList (shiny::icon("info")), textOutput("textpHinfo"), br(), tags$img(src="ph.png"), br(), 
			                   textOutput("textpHinfo2"), br(), tags$img(src="KAB.png"))
			  ),
			  
			  tags$head(tags$style(HTML(" #textpH {font-size: 18px;color:solidgrey; font:italic }"))),
			  tags$head(tags$style(HTML(" #textpH1 {font-size: 15px;color:solidgrey; font:italic }"))),
			  tags$head(tags$style(HTML(" #textpHinfo {font-size: 15px;color:black;font:italic}"))),
			  tags$head(tags$style(HTML(" #textpHinfo1 {font-size: 15px;color:grey;font:bold}"))),
			  tags$head(tags$style(HTML("#textpHinfo2 {font-size: 15px;color:black; font:italic}"))),
			  tags$head(tags$style(HTML(" #textpHinfo3 {font-size: 15px;color:grey;font:bold}"))),
			  
			  tags$head(tags$style(HTML(" #plotinfo {font-size: 17px;color:black;font:bold}"))),
			  tags$head(tags$style(HTML(" #title1 {font-size: 18px;color:red;font:bold}"))),
			  tags$head(tags$style(HTML(" #segmentinfo {font-size: 14px;color:black;font:bold}"))),
			  tags$head(tags$style(HTML(" #title2 {font-size: 18px;color:goldenrod;font:italic}"))),
			  tags$head(tags$style(HTML(" #geominfo {font-size: 14px;color:black;font:bold}")))
		  
			 
			  
			
			)
		    
	)
	)) ,
  
  tabPanel(h3("Sources"),
           
           mainPanel(width=4, 
                     h3 ("References"),
                     br(),
                     "J. Kamphues (2014):", strong("Supplemente zur Tierern\u00E4hrung f\u00FCr Studium und Praxis"), 
                     ", 14. Auflage, M.& H. Schaper GmbH, Hannover",
                     
                     br(),
                     br(),
                     "M. Meyer und J. Zentek (2016):",
                     strong("Ern\u00E4hrung des Hundes: Grundlagen-F\u00FCtterung-Di\u00E4tetik"),
                     ", 8. Auflage, Enke Verlag, Stuttgart",
                     br(),
                     br(),
                     
                     p( "S.W. Souci, W. Fachmann und H. Kraut (2000):", strong("Die Zusammensetzung der Lebensmittel: N\u00E4hrwert-Tabellen"), ", 6. Auflage, medpharm Scientific Publishers, Stuttgart"),
                    
                     
                     
                     
                     br(),
                     br(),
                     
                     br(),
                     br(),
                     br(),
                     br(),
                     
                     br(),
                     br(),
                     br()
                     
                     
           )
  )
  
  
  
  
  
  
  )
)




