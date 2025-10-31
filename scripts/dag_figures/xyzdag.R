library(dagitty)
library(ggdag)
library(ggplot2)
library(stringr)


dag <- dagitty('dag {
bb="-1.601,-1.985,1.97,1.562"
X [pos="-0.086,-1.025"]
Y [pos="0.428,-1.025"]
Z [pos="0.171,-0.418"]
X -> Y
X -> Z
Y -> Z
}
')


# Use ggdag to plot the DAG
dag_plot <- ggdag(dag, text = FALSE) + 
  geom_text(data=dag, aes(x=x, y=y+0.1, label=name)) +
  theme_dag()

dag_plot

pdf(file = "plots/xyz_example_dag.pdf", width = 4, height = 3.5)
dag_plot
dev.off()