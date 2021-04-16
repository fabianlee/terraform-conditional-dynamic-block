
locals {

  # array of host names
  host_list = [ "firstArrayItem", "secondArrayItem", "thirdArrayItem" ]

  # map of host names
  host_map = {
    "host-1" = { os_code_name = "focal", octetIP = "210", vcpu=4, memoryMB=1024*12, incGB=60 },
    "host-2" = { os_code_name = "focal", octetIP = "211", vcpu=4, memoryMB=1024*4, incGB=60 },
    "host-3" = { os_code_name = "focal", octetIP = "211", vcpu=4, memoryMB=1024*4, incGB=60 },
  }
}

resource "template_file" "listcontent" {
  for_each = toset(local.host_list)

  template = file("${path.module}/${ index(local.host_list,each.key)==0 ? "hello":"bye"  }.template")

  vars = {
    name = "${each.key} at index ${index(local.host_list,each.key)}"
  }
}

resource "template_file" "mapcontent" {
  for_each = local.host_map

  template = file("${path.module}/${ index(keys(local.host_map),each.key)==0 ? "hello":"bye" }.template")

  vars = {
    name = "${each.key} at index ${index(keys(local.host_map),each.key)}"
  }
}

output "host_list" {
  value = values(template_file.listcontent)[*].rendered
}
output "host_map" {
  value = values(template_file.mapcontent)[*].rendered
}


#output "map_attr_mb" {
#  value = [ for h in local.host_map :  h.memoryMB ]
#}
#output "map_attr_keys" {
#  value = [ for key,val in local.host_map :  key ]
#}
#output "map_attr_formatted_vals" {
#  value = [ for key,val in local.host_map :  format("%s with memory %sMB",key,val.memoryMB) ]
#}

