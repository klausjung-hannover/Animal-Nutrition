#library("jpeg")
library(ggplot2)
library (grid)
library (gridExtra)
library (gtable)
library(RColorBrewer)  
library (shiny)
library (dplyr)
library (forcats)
library (shinythemes)
library (shinyWidgets)
library (shinyEffects)
library (shinyjs)
library (bsplus)
library (jpeg)




function(input, output,session) {
 

  #Tabelle mit allen Werten (aus den Werten des Energiegehalt werden die Futtermengen berechnet)
  futtermittel <- read.table ("tabellen\\FuttermittelWerte.txt",header=T,sep="\t")
  
  #Futtermenge =  Tabelle fuer den ME Gehalt (mit den ME Werten wird nicht gerechnet)
  futtermenge<- read.table ("tabellen\\FuttermittelWerte.txt",header=T,sep="\t")
  futtermenge <- futtermenge[futtermenge$Mineral == "ME(MJ)" & futtermenge$Einzelfuttermittel != "Salz" & futtermenge$Einzelfuttermittel != "Eischale",]
  
  
  bedarf <-read.table ("tabellen\\Bedarf.txt",header=T,sep="\t")
  testi <- list("Keule", "Rippe","Kaese","Quark","Reis","Kartoffeln","Haferflocken","Pflanzenoel")
 
  ###Prophylaxe-Werte
  TSTabelle <- read.table("tabellen\\TSGesamt.txt",header=T)

  
  
  output$plot <- renderPlot({
   a<-paste0("input$",input$hauptkomp)
   if (a != "input$"){hauptkomponente <- eval(parse(text = a)) }
   else {hauptkomponente<-0}
   
   nebenkomponente <- (input$Reis) + (input$Keule)+ (input$Rippe) + (input$Kaese)+(input$Quark)+(input$Kartoffeln)+(input$Haferflocken)- (hauptkomponente)
   hk = input$hauptkomp

  
    observe({
      updateSliderInput(session, input$hauptkomp, min=0, max=100, value= 100 - nebenkomponente)
    })
    

    observe(
        for (i in testi){
        if (i!= input$hauptkomp & hk != input$hauptkomp){
        updateSliderInput(session,i,value=0)
         }
        }
      )
    
    

    observeEvent (nebenkomponente, {
      for (i in testi)
      if ((nebenkomponente > 100) & (i != input$hauptkomp)) {
        
            updateSliderInput (session, i, value= 0)
            showNotification(id="error", duration=6 ,
              HTML(
              paste(h3("Fehler:") , 
                    #'<br/>', 
                    h5("The composed ration exceed the energie requierment of the dog.") , h4("Please select a new ration !"))
              ))
      }
      
        })
    
  
  
    energiebedarf <- 0.4* (input$kg^0.75)
  
    
    #futtermittel[futtermittel$Einzelfuttermittel=="Keule",]$Wert <- futtermittel [futtermittel$Einzelfuttermittel=="Keule",]$Wert/100 *(input$Keule/100)*input$kg^0.75 *0.4

    
    futtermittel[futtermittel$Einzelfuttermittel=="Keule",]$Wert <- futtermittel [futtermittel$Einzelfuttermittel=="Keule",]$Wert *(input$Keule/100)* (energiebedarf/futtermittel[futtermittel$Einzelfuttermittel == "Keule" & futtermittel$Mineral == "ME(MJ)",]$Wert)
    futtermittel[futtermittel$Einzelfuttermittel=="Rippe",]$Wert <- futtermittel [futtermittel$Einzelfuttermittel=="Rippe",]$Wert *(input$Rippe/100)* (energiebedarf/futtermittel[futtermittel$Einzelfuttermittel == "Rippe" & futtermittel$Mineral == "ME(MJ)",]$Wert)
    futtermittel[futtermittel$Einzelfuttermittel=="Kaese",]$Wert <- futtermittel [futtermittel$Einzelfuttermittel=="Kaese",]$Wert *(input$Kaese/100)* (energiebedarf/futtermittel[futtermittel$Einzelfuttermittel == "Kaese" & futtermittel$Mineral == "ME(MJ)",]$Wert)
    futtermittel[futtermittel$Einzelfuttermittel=="Quark",]$Wert <- futtermittel [futtermittel$Einzelfuttermittel=="Quark",]$Wert *(input$Quark/100)* (energiebedarf/futtermittel[futtermittel$Einzelfuttermittel == "Quark" & futtermittel$Mineral == "ME(MJ)",]$Wert)
    futtermittel[futtermittel$Einzelfuttermittel=="Reis",]$Wert <- futtermittel [futtermittel$Einzelfuttermittel=="Reis",]$Wert *(input$Reis/100)* (energiebedarf/futtermittel[futtermittel$Einzelfuttermittel == "Reis" & futtermittel$Mineral == "ME(MJ)",]$Wert)
    futtermittel[futtermittel$Einzelfuttermittel=="Kartoffeln",]$Wert <- futtermittel [futtermittel$Einzelfuttermittel=="Kartoffeln",]$Wert *(input$Kartoffeln/100)* (energiebedarf/futtermittel[futtermittel$Einzelfuttermittel == "Kartoffeln" & futtermittel$Mineral == "ME(MJ)",]$Wert)
    futtermittel[futtermittel$Einzelfuttermittel=="Haferflocken",]$Wert <- futtermittel [futtermittel$Einzelfuttermittel=="Haferflocken",]$Wert *(input$Haferflocken/100)* (energiebedarf/futtermittel[futtermittel$Einzelfuttermittel == "Haferflocken" & futtermittel$Mineral == "ME(MJ)",]$Wert)
    #futtermittel[futtermittel$Einzelfuttermittel=="Karotten",]$Wert <- futtermittel [futtermittel$Einzelfuttermittel=="Karotten",]$Wert *(input$Karotten/100)* (energiebedarf/futtermittel[futtermittel$Einzelfuttermittel == "Karotten" & futtermittel$Mineral == "ME(MJ)",]$Wert)
    

  
    
    
    #### falls numericInput = NULL
    
    if (NA %in% futtermittel[futtermittel$Einzelfuttermittel=="Salz",]$Wert !=TRUE){
      futtermittel[futtermittel$Einzelfuttermittel=="Salz",]$Wert <- futtermittel [futtermittel$Einzelfuttermittel=="Salz",]$Wert *(input$Salz/100)#* (energiebedarf/futtermittel[futtermittel$Einzelfuttermittel == "Salz" & futtermittel$Mineral == "ME(MJ)",]$Wert
          }
    futtermittel[futtermittel$Einzelfuttermittel=="Eischale",]$Wert <- futtermittel [futtermittel$Einzelfuttermittel=="Eischale",]$Wert *(input$Eischale/100)#* (energiebedarf/futtermittel[futtermittel$Einzelfuttermittel == "Eischale" & futtermittel$Mineral == "ME(MJ)",]$Wert)
    futtermittel[futtermittel$Einzelfuttermittel=="Diaet",]$Wert <- futtermittel [futtermittel$Einzelfuttermittel=="Diaet",]$Wert *(input$Diaet/100)
                              #Einzelfuttermittel=Zeile Komma= Spalte

                          
    
    bedarf$y <- bedarf$y*input$kg^0.75
	
		 
		 
		                                       
    # if(NA %in% futtermittel[futtermittel$Mineral =="TS",]$Wert !=TRUE){
      TSGesamt = do.call(sum,list(futtermittel[futtermittel$Mineral =="TS",]$Wert,na.rm=TRUE))
      TSTabelle[TSTabelle$Type == "min",-1] <- TSTabelle[TSTabelle$Type == "min",-1]/100 * TSGesamt
      TSTabelle[TSTabelle$Type == "max",-1] <- TSTabelle[TSTabelle$Type == "max",-1]/100 * TSGesamt
    # }
    # else  {
    #   print(futtermittel[futtermittel$Mineral =="TS",]$Wert)
    #   TSGesamt= do.call(sum,list(futtermittel[futtermittel$Mineral =="TS" & futtermittel$Einzelfuttermittel != "Salz",]$Wert))
    # }
    # if(NA %in% futtermittel[futtermittel$Einzelfuttermittel =="Salz" ,]$Wert){
    #   futtermittel[futtermittel$Einzelfuttermittel =="Salz",]$Wert <- 0
    #               }

    

			
		observeEvent(input$hauptkomp, {
		     if (TSGesamt > 0){

          output$textpH <- renderText ({paste(
			                                    futtermittel[futtermittel$Mineral=="pH-Wert", ]$Wert[1])
    
        })
          
          output$textpH1 <- renderText ({"Recomended urine pH for prophylaxis: 6.6- 6.7"})
		}
		     })
		
		output$textpHinfo <- renderText ({paste("The average urine pH-level of a dog is estimated by the subsequent formula:" )})
	
		output$textpHinfo2 <- renderText ({paste("Dietary Cation-Anion-Balance, DCAB is calculated as follows:")})  
	
		KAB <- (50*sum(futtermittel[futtermittel$Mineral=="Ca(mg)",]$Wert/1000))+(82*sum(futtermittel[futtermittel$Mineral=="Mg(mg)",]$Wert/1000))+(43*sum(futtermittel[futtermittel$Mineral=="Na(mg)",]$Wert/1000))+(26*sum(futtermittel[futtermittel$Mineral=="K(mg)",]$Wert/1000))-(65*sum(futtermittel[futtermittel$Mineral=="P(mg)",]$Wert/1000))-(28*sum(futtermittel[futtermittel$Mineral=="Cl(mg)",]$Wert/1000))- (13.4*sum(futtermittel[futtermittel$Mineral=="Met(mg)",]$Wert/1000))-(16.6*sum(futtermittel[futtermittel$Mineral=="Cys(mg)",]$Wert/1000)) 
 
		futtermittel[futtermittel$Mineral=="pH-Wert",]$Wert <- round (futtermittel[futtermittel$Mineral=="pH-Wert",]$Wert+1*(KAB*0.019+6.50), digits=2)
	  

	  
	  
	  futtermittel$Mineral <- factor(futtermittel$Mineral,levels = c("Na(mg)","Ca(mg)","P(mg)","Mg(mg)","K(mg)","Rp(g)","Cl(mg)","Cys(mg)","Met(mg)","ME(MJ)", "pH-Wert","TS")) 
	 
	  
	 
	   futtermenge[futtermenge$Mineral == "ME(MJ)" & futtermenge$Einzelfuttermittel != "Salz" &futtermenge$Einzelfuttermittel != "Eischale",]$Wert <- futtermittel[futtermittel$Mineral == "ME(MJ)" & futtermittel$Einzelfuttermittel != "Salz" &futtermittel$Einzelfuttermittel != "Eischale",]$Wert / futtermenge[futtermenge$Mineral == "ME(MJ)" & futtermenge$Einzelfuttermittel != "Salz" &futtermenge$Einzelfuttermittel != "Eischale",]$Wert * 100
	   futtermenge$Mineral <- NULL
	   
	   
	   print(futtermenge)
	   futtermenge$Einzelfuttermittel <- c("chicken leg","prime rib","cheese","quark","rice","potato","oats","complementary feed")
	   names(futtermenge) <- c("feed component","amount(g)")
	   
	   print(futtermenge)
	   
	   futtermenge <- futtermenge[futtermenge$"amount(g)" !=0,]
	 
	   output$table <- renderTable({futtermenge})
	   
	 
	   energie <- sum(round(futtermittel[futtermittel$Mineral == "ME(MJ)" & futtermittel$Wert != 0,]$Wert, digits = 2))
	  
	   observeEvent (input$hauptkomp, {
	     if (TSGesamt > 0){
	     output$energie <- renderText ({paste("Energy content of the diet:",energie , "ME(MJ)" )})
	     }
	   })
	   

	   ggplot()+
		  
	      geom_bar (data=(futtermittel[futtermittel$Mineral != "Met(mg)" & futtermittel$Mineral != "Cl(mg)" & futtermittel$Mineral != "Cys(mg)" & futtermittel$Mineral != "pH-Wert"& futtermittel$Mineral != "TS" & futtermittel$Mineral!= "ME(MJ)",]), stat= "identity", aes(fill=Einzelfuttermittel, y=Wert, x=Mineral))+
	 
	     scale_y_continuous(
	     sec.axis= sec_axis(~. /10, name= expression("crude protein CP (g)")))+
	     ylab("minerals (mg)\n")+
	     geom_segment(data=bedarf, size=1, linetype="solid", color="red",aes (x=start, y=y, xend=finish, yend=y))+
	     geom_rect (data=TSTabelle, aes(xmin=0.6, xmax=1.4, ymin=TSTabelle[TSTabelle$Type=="min",]$Na, ymax=TSTabelle[TSTabelle$Type=="max",]$Na), fill="goldenrod", size=0.2, color="black")+
	     geom_rect (data=TSTabelle, aes (xmin=2.6, xmax= 3.4, ymin=TSTabelle[TSTabelle$Type=="min",]$P,ymax=TSTabelle[TSTabelle$Type=="max",]$P), fill="goldenrod", size=0.2, color="black")+
	     geom_rect (data=TSTabelle, aes (xmin=3.6, xmax= 4.4, ymin=TSTabelle[TSTabelle$Type=="min",]$Mg,ymax=TSTabelle[TSTabelle$Type=="max",]$Mg), fill="goldenrod", size=0.2, color="black")+
	     geom_rect (data=TSTabelle, aes (xmin=5.6, xmax= 6.4, ymin=TSTabelle[TSTabelle$Type=="min",]$Rp,ymax=TSTabelle[TSTabelle$Type=="max",]$Rp), fill="goldenrod", size=0.2, color="black")+
	      
	    
	    ############## Layout Plot
		

	    theme_light() +
		 
	    theme(plot.background=element_rect(fill="white"),
		      
	        plot.title = element_text(size = 5, face = "bold"),
		      legend.title = element_blank(), 
		      legend.text=element_text(size=15),
		      legend.position = "bottom",
		      legend.justification = "left",
		      legend.background = element_rect( linetype="solid", colour= "grey"),
		      legend.margin = margin(5,5,5,5),
		      legend.box.margin = margin(10,20,20,0), 
		      axis.text.y = element_text(colour = "black", size = 12),
		      axis.title.y = element_text (size=13),
		      axis.title.x = element_blank (),
		      axis.text.x = element_text(size=12, colour= "black", face ="bold")) +
	        scale_x_discrete(name="Mineralstoffe", labels= c("Na(mg)", "Ca(mg)", "P(mg)", "Mg(mg)", "K(mg)", "CP(g)"))+
	        scale_fill_discrete(name = "feed component", labels = c("complementary feed", "egg-shell", "oats", "cheese",  "potatoe", "chicken leg", "quark", "rice","prime rib cow", "salt"))+
	        guides(fill=guide_legend(nrow=4, byrow=F))
	        
	
	
	
	   })


	   output$plotinfo <- renderText({paste("The barplot indicates the nutriet and mineral supply, reached by the diet composition.")})
	   output$title1 <- renderText ({"Daily energy need"})
	   output$segmentinfo <- renderText ({paste("The daily nutrient and mineral needs of the dog is shown with this graphic through red horizontal lines within the barplot.")})
	   output$title2 <- renderText ({"Struvite stones prevention diet"})
	   output$geominfo <- renderText ({paste("Diets for dogs with disposition for struvite stones should be restricted in protein, phosphorus and magnesium. The recommended amount is illustrated in this graphic by a yellow rectangle within the barplot."
	                                         )})
     
 
	

}

