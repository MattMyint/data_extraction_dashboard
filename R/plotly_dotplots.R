## hey man
pat_diag <- aggregate(diag_df, by = list(Patient = diag_df$Patient.No, Diagnosis = diag_df$Diagnosis.Description), length)
