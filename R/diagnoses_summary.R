source("R/load_clean.R")
card_diag <- readLines(con = "cardio_diags.txt")

diag_by_pat <- list()
#all_diags <- unique(diag_df$Diagnosis.Description)
#writeLines(text = all_diags, con = "all_diags.txt")
for(i in unique(diag_df$Patient.No)){
    diag_by_pat[[i]] <- unique(diag_df[diag_df$Patient.No == i, "Diagnosis.Description"])
}

check_diag <- function(patNo, diagType = 'cardio'){
    if(diagType == "fh"){
        bool_diag <- any(c("FAMILIAL HYPERCHOLESTEROLEMIA", "FAMILIAL HYPERCHOLESTEROLAEMIA") %in% diag_by_pat[[patNo]])
    }else{
        bool_diag <- any(card_diag %in% diag_by_pat[[patNo]])
    }
    return(bool_diag)
}

prior_meds <- function(patNo){
    pat_df <- meds_df[meds_df$Patient.No == patNo & meds_df$Service.End.Date < ldl_df[ldl_df$PatientNo == patNo, "ResultDate"],]
    prior_prescription <- pat_df[order(pat_df$Service.End.Date, decreasing = T)[1], "Service.Description"]
    return(prior_prescription)
}

output <- list("PatientNumber" = ldl_df$PatientNo, NRIC = ldl_df$DeidentifiedNRIC, Age = ldl_df$Age, LDLc = ldl_df$LDLc)
output[['FH Diagnosis']] <- sapply(output$PatientNumber, check_diag, diagType = 'fh', USE.NAMES = FALSE)
output[['Any cardiac diagnosis']] <- sapply(output$PatientNumber, check_diag, USE.NAMES = FALSE)
output[['Prior Medication']] <- sapply(output$PatientNumber, prior_meds, USE.NAMES = FALSE)
output <- as.data.frame(output)
output <- output[order(output$LDLc, decreasing = T),]
row.names(output) <- 1:nrow(output)

filename <- paste0("summary_report_", Sys.Date(), ".csv")
write.csv(output, file = filename)
