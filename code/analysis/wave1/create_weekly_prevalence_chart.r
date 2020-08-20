#####
# Create weekly charts with prevalence
library(data.table)
library(ggplot2)
library(ggthemes)

setwd("~")

# Load the per-group prevalence computed by estimate_prevalence_by_variable.r
load("estimates/wave1/prevalence_by_variable_level.rdata")

# Rename tests
prevalence_by_variable_level[serotest == "IgA_or_G_or_M_testC", serotest := "ELISA"]
prevalence_by_variable_level[serotest == "IgG_testB", serotest := "CMIA"]

# Keep only univariate prevalence for interview week
prevalence_by_interview_week <- prevalence_by_variable_level[ prevalence_type == "univariate" & variable == "interview_week"]
setnames(prevalence_by_interview_week, "variable_level", "week")

prevalence_by_interview_week[, week := as.numeric(week)]
prevalence_by_interview_week[week == 21, week_label := "May 18-24"]
prevalence_by_interview_week[week == 22, week_label := "May 25-31"]
prevalence_by_interview_week[week == 23, week_label := "June 1-7"]
prevalence_by_interview_week[week == 24, week_label := "June 8-14"]
prevalence_by_interview_week[week == 25, week_label := "June 15-21"]
prevalence_by_interview_week[week == 26, week_label := "June 22-28"]

# Keep only naive prevalence for draw sample week
prevalence_by_draw_sample_week <- prevalence_by_variable_level[ prevalence_type == "naive" & variable == "draw_week"]
setnames(prevalence_by_draw_sample_week, "variable_level", "week")

prevalence_by_draw_sample_week[, week := as.numeric(week)]
prevalence_by_draw_sample_week[week == 21, week_label := "May 18-24"]
prevalence_by_draw_sample_week[week == 22, week_label := "May 25-31"]
prevalence_by_draw_sample_week[week == 23, week_label := "June 1-7"]
prevalence_by_draw_sample_week[week == 24, week_label := "June 8-14"]
prevalence_by_draw_sample_week[week == 25, week_label := "June 15-21"]
prevalence_by_draw_sample_week[week == 26, week_label := "June 22-28"]


## Plot by interview week
prevalence_by_interview_week_plot <- ggplot(prevalence_by_interview_week, aes(x = week, y = pointest, color = serotest)) +
											geom_point(size = 2, position = position_dodge(width=0.5)) +
											geom_errorbar(aes(ymin = lowerbound, ymax = upperbound), width = 0.2, position = position_dodge(width=0.5)) +
											geom_text(aes(label = paste0(pointest, "%")), hjust = 1.2, vjust = 0.2, size = 6, position = position_dodge(width=0.5)) +
											scale_y_continuous(name = "Prevalence (single imputation model), %") +
											scale_x_continuous(	name = "Week of phone call inviting to participate in the study",
																breaks = unique(prevalence_by_interview_week$week), labels = unique(prevalence_by_interview_week$week_label),
																expand = c(0.1, 0)) +
											labs(color = "Test") +
											theme_minimal() +
											theme(panel.grid.minor = element_blank(), axis.text.y = element_text(size = 12), text = element_text(size = 15), legend.position = "bottom")

ggsave(prevalence_by_interview_week_plot, file = "media/prevalence_by_interview_week_plot.pdf")



## Plot by draw sample week
prevalence_by_draw_sample_date_plot <- ggplot(prevalence_by_draw_sample_week, aes(x = week, y = pointest, color = serotest)) +
											geom_point(size = 2, position = position_dodge(width=0.5)) +
											geom_errorbar(aes(ymin = lowerbound, ymax = upperbound), width = 0.2, position = position_dodge(width=0.5)) +
											geom_text(aes(label = paste0(pointest, "%")), hjust = 1.2, vjust = 0.2, size = 6, position = position_dodge(width=0.5)) +
											scale_y_continuous(name = "Prevalence (naïve), %") +
											scale_x_continuous(	name = "Week of blood sample draw",
																breaks = unique(prevalence_by_draw_sample_week$week), labels = unique(prevalence_by_draw_sample_week$week_label), 
																expand = c(0.1, 0)) +
											labs(color = "Test") +
											theme_minimal() +
											theme(panel.grid.minor = element_blank(), axis.text.y = element_text(size = 12), text = element_text(size = 15), legend.position = "bottom")

ggsave(prevalence_by_draw_sample_date_plot, file = "media/prevalence_by_draw_sample_date_plot.pdf")
