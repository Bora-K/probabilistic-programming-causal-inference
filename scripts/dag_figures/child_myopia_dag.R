library(dagitty)
library(ggdag)
library(ggplot2)
library(stringr)

dag <- dagitty('dag {
  bb="0,0,1,1"
  "Child myopia" [pos="0.470,0.348"]
  "Parental Myopia" [pos="0.435,0.530"]
  Nightlight [pos="0.400,0.348"]
  "Parental Myopia" -> "Child myopia"
  "Parental Myopia" -> Nightlight
  Nightlight -> "Child Myopia"
}')

dag <- tidy_dagitty(dag)

# Use ggdag to plot the DAG
dag_plot <- ggdag(dag, text = FALSE) + 
  geom_dag_node(shape = 21, color = "black") +
  geom_dag_edges(
    data = ggdag_edges(dag) %>% filter(from == "Nightlight" & to == "Child Myopia"),
    linetype = "dashed"
  ) + 
  geom_text(data = subset(dag$data, name == "Parental Myopia"), 
           aes(x = x, y = y+0.05, label = name)) +
  geom_text(data = subset(dag$data, name != "Parental Myopia"), 
            aes(x = x, y = y-0.05, label = name)) +
  theme_dag() +
  theme(legend.position = "none")

dag_plot

pdf(file = "plots/parent_nightlight.pdf", width = 5.5, height = 3.5)
dag_plot
dev.off()