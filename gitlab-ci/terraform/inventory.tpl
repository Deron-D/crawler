[all]
%{ for i in range(length(names) - 1) ~}
${names[i]} ansible_host=${addrs[i]}
%{ endfor ~}
