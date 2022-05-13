
resource "local_file" "proxy_conf" {
   filename = "../../${path.module}/proxy2.conf.js"
#filename="../../"
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




