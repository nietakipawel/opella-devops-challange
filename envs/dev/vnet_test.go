package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)


func TestVNetModule(t *testing.T) {
    uniqueSuffix := random.UniqueId()

    terraformOptions := &terraform.Options{

        TerraformDir: "../../modules/vnet", 


        Vars: map[string]interface{}{
            "vnet_name":           fmt.Sprintf("vnet-test-%s", uniqueSuffix),
            "location":            "westeurope",
            "resource_group_name": fmt.Sprintf("rg-test-%s", uniqueSuffix),
            "address_space":       []string{"10.0.0.0/16"},
            "subnets": map[string]interface{}{
                "subnet1": map[string]interface{}{
                    "address_prefixes": []string{"10.0.1.0/24"},
                },
                "subnet2": map[string]interface{}{
                    "address_prefixes": []string{"10.0.2.0/24"},
                },
            },
            "tags": map[string]string{
                "environment": "dev",
            },
        },


        Upgrade: true,
    }


    defer terraform.Destroy(t, terraformOptions)


    terraform.InitAndApply(t, terraformOptions)


    vnetID := terraform.Output(t, terraformOptions, "vnet_id")
    subnet1ID := terraform.Output(t, terraformOptions, "subnet_ids")


    if vnetID == "" {
        t.Fatalf("VNET was not created! Output 'vnet_id' is empty")
    }
    fmt.Printf("VNET ID: %s\n", vnetID)


    if subnet1ID == "" {
        t.Fatalf("Subnet 1 was not created! Output 'subnet_ids' is empty")
    }
    fmt.Printf("Subnet1 ID: %s\n", subnet1ID)

    expectedVNetName := fmt.Sprintf("vnet-test-%s", uniqueSuffix)
    actualVNetName := terraform.Output(t, terraformOptions, "vnet_name")

    if actualVNetName != expectedVNetName {
        t.Fatalf("VNET name mismatch: expected '%s', got '%s'", expectedVNetName, actualVNetName)
    }
}
