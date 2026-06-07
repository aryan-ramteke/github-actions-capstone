import boto3
import json
import pdb

class AWSUtility():
    
    def __init__(self):
        self.s3 = self.get_client("s3")
        self.ec2 = self.get_client("ec2")
        self.buckets = []
        self.instances = []
        # self.bkt_dict = {}
        # self.ec2_dict = {}
        
    def get_client(self,service):
        client = boto3.client(service)
        return client

    def list_buckets(self):
        response = self.s3.list_buckets()
        print("Bucket Names:")
        for bucket in response["Buckets"]:
            print(bucket["Name"])
            self.buckets.append(bucket["Name"])
        # self.bkt_dict["Buckets"] = self.buckets
        # print(self.bkt_dict)
        # print()
    
    def list_instances(self):
        response = self.ec2.describe_instances()
        print("EC2 Instances:")
        reservations = response["Reservations"]
        for  instance in reservations:
            for tag in instance["Instances"][0]["Tags"]:
                if tag["Key"] == "Name":
                    print(tag["Value"])
                    self.instances.append(tag["Value"])
        # self.ec2_dict["Instances"] = self.instances
        # print(self.ec2_dict)
        # print('\n')
        
    def create_bucket(self,bucket_name,region='ap-south-1'):
        self.s3.create_bucket(Bucket=bucket_name, 
                              CreateBucketConfiguration= {'LocationConstraint': region}
                              )

    def save_usage(self,file_name):
        with open(file_name,'w') as file:
            self.list_buckets()
            self.list_instances()
            combined_data = {"Buckets": self.buckets,"instances": self.instances}
            print(combined_data)
            print(json.dumps(combined_data))
            file.write(json.dumps(combined_data))
            
    def show_usage(self):
        self.list_buckets()
        self.list_instances()
        combined_data = {"Buckets": self.buckets,"instances": self.instances}
        return combined_data
     
def aws_usage():
    utility = AWSUtility()
    return utility.show_usage()

if __name__ == "__main__":
    # pdb.set_trace()
    utility = AWSUtility()
    print(utility.show_usage)