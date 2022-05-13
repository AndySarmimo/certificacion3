
resource "local_file" "proxy_conf" {
#   filename = "../../${path.module}/proxy2.conf.js"
filename="../../angularFrontend/certi3Frontend/proxy.conf.js"
#   file_permission = "666"
  content  = <<-EOT
   const PROXY_CONFIG ={
    '/api':{
        'target': "${var.smm_lb_arn}:${var.smm_db_port}",
         'pathRewrite':{
             '^/api':''
         }
    }
}
module.exports =  PROXY_CONFIG
EOT
}




