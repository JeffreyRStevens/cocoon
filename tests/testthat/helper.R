set.seed(2024)
df <- data.frame(a = 1:10,
                 b = 2:11,
                 c = c(1, 8, 3, 7, 8, 2, 4, 1, 4, 5),
                 d = sample(0:1, 10, replace = TRUE),
                 e = rep(1:2, 5))
test_corr <- cor.test(df$a, df$b)
test_corr2 <- cor.test(df$a, df$c)
test_easycorr <- correlation::correlation(df, select = "a", select2 = "c")
test_easycorr2 <- correlation::correlation(df, select = "a", select2 = "c", method = "spearman")
test_easycorr3 <- correlation::correlation(df, select = "a", select2 = "c", method = "kendall")
test_ttest1 <- t.test(df$a, mu = 5)
test_ttest <- t.test(df$a, df$b)
test_ttest2 <- t.test(df$a, c(df$b, 120))
test_ttest3 <- suppressWarnings(wilcox.test(df$a, mu = 5))
test_ttest4 <- suppressWarnings(wilcox.test(df$a, df$b))
test_ttest5 <- suppressWarnings(wilcox.test(df$a, c(df$b, 120)))
test_chisq <- chisq.test(as.table(rbind(c(762, 327, 468), c(484, 239, 477))))
test_aov <- aov(c ~ a, data = df)
test_lm <- lm(c ~ a, data = df)
test_glm <- glm(d ~ a, data = df, family = binomial)
test_lmer <- suppressMessages(lme4::lmer(c ~ a + (1 | e), data = df))
test_glmer <- suppressMessages(lme4::glmer(d ~ a + (1 | e), data = df, family = binomial))
test_lmer2 <- suppressMessages(lmerTest::lmer(c ~ a + (1 | e), data = df))
test_bf <- BayesFactor::ttestBF(df$a, mu = 5)

suppressPackageStartupMessages({
  library(rlang, warn.conflicts = FALSE, quietly = TRUE, verbose = FALSE)
})
