## Lecture 20

## Simulation study

B = 10000
pval.Classical = pval.Welch = vector(length = B)
set.seed(123)
for(i in 1:B){
  x = rnorm(100, mean = 0, sd = 1)          # both samples have the same mean
  y = rnorm(20, mean = 0, sd = 3)           # smaller sample has bigger variance
  pval.Welch[i] = t.test(x, y, var.equal = FALSE)$p.val
  pval.Classical[i] = t.test(x, y, var.equal = TRUE)$p.val
}
mean(pval.Welch < .05)        # Rejects about 5% of the time.
mean(pval.Classical < .05)    # Rejects far too often!!


## Plant growth

data("PlantGrowth")
library(ggplot2)
ggplot(PlantGrowth,
       aes(y = weight, x = group,
           colour = group)) +
  geom_boxplot(coef = 10) +
  geom_jitter(width=0.1, size = 5) +
  theme_bw(base_size = 20) +
  theme(legend.position = "none") +
  labs(y = "Weight (g)",
       x = "Group")

plant_anova = aov(weight ~ group, data = PlantGrowth)
plant_anova
summary(plant_anova)

## Penguins

library(palmerpenguins)
library(ggbeeswarm)
penguins
ggplot(penguins,
       aes(y = bill_length_mm, x = species,
           colour = species)) +
  geom_boxplot(coef = 10) +
  geom_beeswarm(alpha = 0.5) +
  theme_bw(base_size = 20) +
  theme(legend.position = "none") +
  labs(y = "Bill length (mm)",
       x = "Species")

penguin_anova = aov(bill_length_mm ~ species, data = penguins)
penguin_anova
summary(penguin_anova)
