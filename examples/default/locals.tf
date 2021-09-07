locals {
  aws_auth_data = [
    {
      rolearn  = "fakearnbecauseitdoesntmatter"
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = [
        "system:bootstrappers",
        "system:nodes"
      ]
    }
  ]
}
