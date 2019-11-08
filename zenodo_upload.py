#!/usr/bin/python3
import requests, sys, pprint, os

zenodo_access_token = str(sys.argv[1])
params_zenodo = dict()
params_zenodo['access_token']=zenodo_access_token

# Create the deposit resource
url = "https://zenodo.org/api/deposit/depositions/2648163"
headers = {"Content-Type": "application/json"}

response = requests.get(url, params=params_zenodo)
pprint.pprint(response.json())
# In the new files API we use a PUT request to a 'bucket' link, which is the container for files
# bucket url looks like this: 'https://sandbox.zenodo.org/api/files/12341234-abcd-1234-abcd-0e62efee00c0'
bucket_url = response.json()['links']['bucket']

# We pass the file object (fp) directly to request as 'data' for stream upload
# the target URL is the URL of the bucket and the desired filename on Zenodo seprated by slash
fname="GOMAP.sif"
#fname="../GOMAP-singularity/icommands.simg"

upload_url = bucket_url + "/" + os.path.basename(fname)

print(upload_url)

with open(fname, 'rb') as fp:
    res = requests.put(
        upload_url,
        data=fp,
        # No headers included in the request, since it's a raw byte request
        params=params_zenodo
    )
print(res.json())