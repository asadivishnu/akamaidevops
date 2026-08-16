terraform init
terraform import akamai_edge_hostname.waap-akamaiuwebfraud-com-edgekey-net ehn_5055499,ctr_V-3YSNQK2,grp_211815
terraform import akamai_property._2608-x4s6 prp_1393817,ctr_V-3YSNQK2,grp_211815,2
terraform import akamai_property_activation._2608-x4s6-staging prp_1393817:STAGING
terraform import akamai_property_activation._2608-x4s6-production prp_1393817:PRODUCTION
