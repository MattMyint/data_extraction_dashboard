## prepare dataframes for plotly
require(plotly)
ldl.dot = ldl_df %>% 
    arrange(LDLc) %>% # sort using the numeric variable that interest you
    mutate(rounded = (LDLc) - ( (LDLc) %% 0.14 ) ) %>% # This attributes a bin to each observation. Here 0.2 is the size of the bin.
    mutate(y=ave(rounded, rounded, FUN=seq_along)) %>% # This calculates the position on the Y axis: 1, 2, 3, 4...
    mutate(text=paste0("Patient No: ", PatientNo, "\n", "Age: ", Age, "\n", "Visit #", VisitNo, "\n", "LDL-c: ", LDLc))

age.dot = ldl_df %>% 
    arrange(Age) %>% 
    mutate(rounded = (Age) - ( (Age) %% 1 ) ) %>% 
    mutate(y=ave(rounded, rounded, FUN=seq_along)) %>% 
    mutate(text=paste0("Patient No: ", PatientNo, "\n", "Age: ", Age, "\n", "Visit #", VisitNo, "\n", "LDL-c: ", LDLc))

visit.dot = ldl_df %>% 
    arrange(VisitNo) %>% 
    mutate(rounded = (VisitNo) - ( (VisitNo) %% 1 ) ) %>% 
    mutate(y=ave(rounded, rounded, FUN=seq_along)) %>% 
    mutate(text=paste0("Patient No: ", PatientNo, "\n", "Age: ", Age, "\n", "Visit #", VisitNo, "\n", "LDL-c: ", LDLc))

## function to generate interactive dotplots
plotly_dotplot <- function(data, size = 5, xlab = "value", d = NULL){
    p <- ggplot(data, aes(x=rounded, y=y, key=PatientNo)) +
        geom_point(aes(text=text), size = size, color = 'skyblue') +
        xlab(xlab) +
        ylab('# of individuals') +
        ylim(0,10) +
        theme_classic() + 
        theme(
            legend.position="none",
            axis.text.y = element_blank(),
            axis.ticks.y = element_blank(),
            axis.line.y = element_blank(),
            axis.text=element_text(size=15)
        )
    if(!is.null(d)){
        p <- p + geom_point(data = data[data$PatientNo == d$key,], 
                            aes(x=rounded, y=y, key=PatientNo, text=text),
                            size = size + 1, color = 'red', inherit.aes = F)
    }
    ggplotly(p, tooltip="text")
}