
# Convert date to Julian day

site <- read.csv("GK_bird_raw_sites.csv", header=T)
head(site)
str(site)

# Since the date is in uniform character format, there was no neeef for additional steps,
# the conversion was straightforward.
# If this is not the case, you will have to do workaround to fix date first.

site$Julian <- as.POSIXlt(site$Date)$yday
View(site)

write.csv(site, file="GK_bird_sites_Julian_day.csv", row.names=F)
