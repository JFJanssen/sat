#!/usr/bin/env ruby
File.open("output/communitySubGraphs.dot", "w") do |f|
  f.write("graph communities { \n  edge[dir=none, color=black]; \n  node[shape=point, color=red];\n  overlap=false;\n")
  
  communities = {}
  subgraphs = {}
  nonSubGraphNodes = Array.new
  colors = { 0 => "aqua", 1 => "blue", 2 => "blueviolet", 3 => "brown", 4 => "cadetblue", 5 => "chartreuse", 6 => "chocolate", 7 => "coral", 8 => "cornflowerblue", 9 => "crimson", 10 => "darkgoldenrod", 11 => "darkgreen", 12 => "darkmagenta", 13 => "darkolivegreen", 14 => "darkorange", 15 => "darkred", 16 => "darkslategray", 17 => "deeppink", 18 => "gold", 19 => "hotpink" }
  counter = 0
  
  # Read community data and build hash
  file = File.open("output/communityMapping.dot", "r")
  while (line = file.gets)
    info = "#{line}".split(' ')
    community = {info[0] => info[1]}
    communities.merge!(community)
    
    if !subgraphs.has_key?(info[1])
      subgraph = {info[1] => "\n  subgraph cluster_" + info[1] + " {\n    label = \"Cluster" + info[1] + "\";\n    edge[dir=none, color=" + colors[counter] + "];\n"}
      subgraphs.merge!(subgraph)
      
      counter += 1
      if counter >= colors.length
        counter = 0
      end
    end
  end
  file.close
  
  # Read original graph file and build a hash
  file = File.open("output/graph.dot", "r")
  while (line = file.gets)
    info = "#{line}".split(' ')
    
    if communities.has_key?(info[0]) && communities.has_key?(info[1]) && communities[info[0]] == communities[info[1]]
      newGraph = {communities[info[0]] => subgraphs[communities[info[0]]] + "    " + info[0] + " -- " + info[1] + ";\n"}
      subgraphs.merge!(newGraph)
    else
      nonSubGraphNodes.push(info[0] + " -- " + info[1])
    end
  end
  file.close
  
  subgraphs.each do |key, value|
    f.write(value + "\n  }")
  end

  nonSubGraphNodes.each do |value|
    f.write("\n  " + value + ";")
  end
  
  f.write("\n}")
end
