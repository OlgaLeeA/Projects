package main

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
)

type Name struct {
	Name string `json:"name"`
}

type Instance struct {
	InstanceId string `json:"instanceId"`
}

var savedInstance Instance

func helloHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var name Name
	err := json.NewDecoder(r.Body).Decode(&name)
	if err != nil {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}

	fmt.Fprintf(w, "Hello, %s!", name.Name)
}

func createEC2Handler(w http.ResponseWriter, r *http.Request) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("ap-northeast-3"),
	})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	svc := ec2.New(sess)
	input := &ec2.RunInstancesInput{
		ImageId:          aws.String("ami-0997b4797ae01c920"),
		InstanceType:     aws.String("t2.micro"),
		MinCount:         aws.Int64(1),
		MaxCount:         aws.Int64(1),
		KeyName:          aws.String("my-key"),
		SecurityGroupIds: aws.StringSlice([]string{"sg-0807f948d4a9a56b5"}),
		TagSpecifications: []*ec2.TagSpecification{
			{
				ResourceType: aws.String("instance"),
				Tags: []*ec2.Tag{
					{
						Key:   aws.String("name"),
						Value: aws.String("myEC2"),
					},
				},
			},
		},
	}

	result, err := svc.RunInstances(input)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	savedInstance.InstanceId = *result.Instances[0].InstanceId
	fmt.Fprintln(w, "Successfully created EC2 instance with ID: "+savedInstance.InstanceId)
}

func terminateEC2Handler(w http.ResponseWriter, r *http.Request) {
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("ap-northeast-3"),
	})
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	svc := ec2.New(sess)
	input := &ec2.TerminateInstancesInput{
		InstanceIds: []*string{
			aws.String(savedInstance.InstanceId),
		},
	}

	_, err = svc.TerminateInstances(input)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	fmt.Fprintln(w, "Successfully terminated EC2 instance with ID: "+savedInstance.InstanceId)
}

func main() {
	http.HandleFunc("/api/hello", helloHandler)
	http.HandleFunc("/api/ec2/create", createEC2Handler)
	http.HandleFunc("/api/ec2/terminate", terminateEC2Handler)
	http.ListenAndServe(":80", nil)
}
