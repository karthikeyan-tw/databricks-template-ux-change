resource "databricks_schema" "schema" {
  for_each = {
    for item in flatten([
      for catalog in var.catalogs[*] : [
        for schema in(can(catalog.schemas[*]) ? catalog.schemas[*] : []) : {
          catalog = catalog.name
          schema  = schema
        }
      ]
    ]) : "${item.catalog}#${item.schema}" => item
  }

  catalog_name = databricks_catalog.catalog[each.value.catalog].name
  name         = each.value.schema
}