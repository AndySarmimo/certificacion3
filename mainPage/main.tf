module "db_ins"{
  source="../database"
  
  
}

module "db_lb"{
    source="../autoscaling"
    
    db_name=module.db_ins.database_db
    db_hostname=module.db_ins.database_hostname
    db_port=module.db_ins.database_port
    db_user=module.db_ins.database_user
    db_pass=module.db_ins.database_pass
}


