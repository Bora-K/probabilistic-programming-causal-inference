library(dagitty)
library(ggdag)
library(ggplot2)
library(stringr)


dag <- dagitty('dag {
bb="-7.112,-2.53,8.783,3.511"
"Cellular Response" [pos="-1.476,-0.962"]
"Gene Expression" [pos="-0.077,-0.975"]
"Genetic Mutation" [pos="-1.476,0.147"]
"Pathological Condition" [pos="-2.555,-0.360"]
"Protein Synthesis" [pos="1.149,0.159"]
"Signal Transduction" [pos="-0.757,-1.632"]
"mRNA Levels" [pos="1.149,-0.438"]
"tRNA Levels" [pos="1.149,0.720"]
"Cellular Response" -> "Pathological Condition"
"Gene Expression" -> "mRNA Levels"
"Genetic Mutation" -> "Pathological Condition"
"Signal Transduction" -> "Cellular Response"
"Signal Transduction" -> "Gene Expression"
"mRNA Levels" -> "Protein Synthesis"
"tRNA Levels" -> "Protein Synthesis"
}
')

dag <- tidy_dagitty(dag)
dag$data$name <- str_replace_all(dag$data$name, fixed(" "), "\n")
dag$data$to <- str_replace_all(dag$data$to, fixed(" "), "\n")

# Use ggdag to plot the DAG
dag_plot <- ggdag(dag, text = FALSE) + 
  geom_text(data=dag, aes(x=x+0.5, y=y, label=name)) +
  theme_dag()

dag_plot

pdf(file = "plots/complex_biological_dag.pdf", width = 7, height = 5)
dag_plot
dev.off()
