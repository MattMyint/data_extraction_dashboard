#### loading LDL table ####
ldl_df <- read.csv("raw_in/DE1901130 - LDL More Than 5.6.csv", stringsAsFactors = F)
ldl_df <- ldl_df[,!colnames(ldl_df) %in% c("X.Test.Code", "X.Short.Text.")]
colnames(ldl_df) <- c("PatientNo","DeidentifiedNRIC","Age","CaseNo","VisitNo","LDLc","ResultDate")
ldl_df$PatientNo <- as.character(ldl_df$PatientNo)
ldl_df$VisitNo <- as.numeric(gsub("\\t", "", ldl_df$VisitNo))
ldl_df$ResultDate <- strptime(gsub("\\t", "", ldl_df$ResultDate), "%d/%m/%Y %H:%M")
#colClasses = c("character","character", "integer", "character", "numeric", "factor", "numeric","factor", "character")

#### loading medication table ####
meds_df <- read.csv("raw_in/3. DE1901130 - Medications.csv", stringsAsFactors = F)
meds_df$Patient.No <- as.character(meds_df$Patient.No)
meds_df$Visit.No <- as.numeric(meds_df$Visit.No)
meds_df$Service.End.Date <- strptime(meds_df$Service.End.Date, "%d/%m/%Y %H:%M")




#### loading diagnosis table ####
diag_df <- read.csv("raw_in/2. DE1901130 - SNOMED DIGANOSIS.csv", stringsAsFactors = F)[,1:6] 
diag_df$Patient.No <- as.character(diag_df$Patient.No)
