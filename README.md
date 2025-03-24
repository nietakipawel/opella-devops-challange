# opella-devops-challange

# Outcomes

## Deliverables
1. [Build a reusable Terraform module to deploy an Azure Virtual Network (VNET)](./modules/vnet/)

- Use this module to create multiple environments in Azure (eg, Develoment and Production), adding a few additional resources of your choice (eg, Blob).
    >- [dev](./envs/dev/main.tf)
    >- [prod](./envs/prod/main.tf)

- Submit your work via one or many GitHub repositories, make them plublic and share the URL with us.
    > For the sake of a quick demo, I decided to follow a monorepo approach. However, for a more robust solution, it would be better to place each module in its own dedicated repository, accompanied by a clear versioning strategy.
- [Please share the terraform plan output. You can use the Azure Free-tier.](./envs/dev/tfplan.txt)
- Make sure your code is clean. Propose tools and processes to help you in this aspect.
    > two aspects: format cleanliness and configuration cleanliness
    > - `terraform fmt`
    > - `checkov`, or any other static code analyzer

Requirements
1. Reusable Module Creation
- Task: Create a Terraform module for provisioning an Azure VNET that can be reused across different setups.Purpose: This should deploy a VNET and related networking resources, designed with flexibility and security in mind. Consider optional features that could enhance network security. 
    > - `NSG` with deny by default approach and `Route Table` as a security proposal, `DDoS` might by another security feature to harden setup (but expensive)
    > - It would be great to enhance this by adding dynamic address space generation for subnets, based on the required subnet size, delegation, and other factors.
- What outputs you would add and why?
> - To simplify it decided to add only two outputs:
> - `vnet_id` - essential for referencing the VNET in other modules, such as network interfaces or virtual machines, 
> - `subnets` - provides access to the IDs of each subnet, which is important when you need to associate resources (e.g., VMs, NICs) with specific subnets.
- [What information would someone need in order to use this module? Bonus points if you automate documentation! (indicate how)](./modules/vnet/generate_readme.tf)
> - module [README.md](./modules/vnet/README.md), generated dynamicly with `mermaid` diagram.

- [Super extra points if your module is tested](./envs/dev/vnet_test.go)
> - Go Terratest might be used to test our code:
> - Example result:
```
                                │ Error: Missing required argument
                                │ 
                                │   with provider["registry.terraform.io/hashicorp/azurerm"],
                                │   on <empty> line 0:
                                │   (source code not available)
                                │ 
                                │ The argument "features" is required, but no definition was found.
                                ╵}
                Test:           TestVNetModule
TestVNetModule 2025-03-24T20:59:22Z retry.go:91: terraform [destroy -auto-approve -input=false -var tags={"environment" = "dev"} -var vnet_name=vnet-test-RVGe5i -var location=westeurope -var resource_group_name=rg-test-RVGe5i -var address_space=["10.0.0.0/16"] -var subnets={"subnet1" = {"address_prefixes" = ["10.0.1.0/24"]}, "subnet2" = {"address_prefixes" = ["10.0.2.0/24"]}} -lock=false]
TestVNetModule 2025-03-24T20:59:22Z logger.go:67: Running command terraform with args [destroy -auto-approve -input=false -var tags={"environment" = "dev"} -var vnet_name=vnet-test-RVGe5i -var location=westeurope -var resource_group_name=rg-test-RVGe5i -var address_space=["10.0.0.0/16"] -var subnets={"subnet1" = {"address_prefixes" = ["10.0.1.0/24"]}, "subnet2" = {"address_prefixes" = ["10.0.2.0/24"]}} -lock=false]
TestVNetModule 2025-03-24T20:59:22Z logger.go:67: 
TestVNetModule 2025-03-24T20:59:22Z logger.go:67: No changes. No objects need to be destroyed.
TestVNetModule 2025-03-24T20:59:22Z logger.go:67: 
TestVNetModule 2025-03-24T20:59:22Z logger.go:67: Either you have not created any objects yet or the existing objects were
TestVNetModule 2025-03-24T20:59:22Z logger.go:67: already deleted outside of Terraform.
TestVNetModule 2025-03-24T20:59:22Z logger.go:67: 
TestVNetModule 2025-03-24T20:59:22Z logger.go:67: Destroy complete! Resources: 0 destroyed.
TestVNetModule 2025-03-24T20:59:22Z logger.go:67: 
--- FAIL: TestVNetModule (2.53s)
FAIL
exit status 1
FAIL    terraform-vnet-test     2.634s
```

2. Infrastructure Setup
- Task: Create a repository and a GitHub pipeline to deploy multiple environments in Azure using your VNET module, plus a couple of additional resources.

- Folder Structure: Set up your code to handle a dev environment in one Azure region (e.g., eastus), with an eye toward scaling to other environments and regions later.
> - simplified structure:
```
/project-root
├── envs
│   └── dev
│   └── prod
```

Hints:

- Argument why would you use Resource Groups or Subscriptions for multiple environments.
> - `Resource Group` isolation is suitable for smaller-scale environments or cases where complete separation isn’t required.
> - `Subscription` isolation provides a more robust solution, ensuring complete environment isolation. When combined with `Terraform workspaces` or `state key variables`, it allows you to use the same codebase across different environments without duplicating configuration, ultimately following DRY and ensuring better scalability and maintenance.

- [Include a virtual machine and one other resources (your choice—think about what’s useful in a dev setup).]](./envs/dev/main.tf)
- Name and label resources to make the environment and region clear.
> - simplified version to add extra tags and naming prefixes, might be extended by extra randomization

- Avoid repeating values—how can you make this flexible?
> - Use Variables for Common Values
> - Use Modules to Encapsulate Logic
> - Build a well-defined, opinionated module that abstracts complex logic, tailoring it to the module's purpose and intended audience.
> - Use Dynamic Blocks for Repetitive Resources
> - Use Terraform Locals

- How might you label resources for better tracking? How would you enforce this?
> - solid governace by introducing mendatory tags, adding tag inheritance

- What outputs might be useful and why?
> - depends on module needs

- [Bonus points if you build a GitHub pipeline and explain the release lifecycle.](.github/workflows/deployment.yml)
> - This is pseudo code (needs to be extended by adding seprated tfstate file as variables, stored ideally on blob storage)