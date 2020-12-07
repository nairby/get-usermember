# get-usermember
#
# Accept list of users and/or groups, recursively return list of all user objects
#
# TODO: optional filter on users
#       error for non-existent object
#       add help text + comments

function get-usermember {
param (
        [parameter(valuefrompipeline)]
        $list
        )

process {
        $list |% {
                $i = get-adobject -ldapfilter "(name=$_)"
                if ($null -eq $i) {
                        @()
                } elseif ($i.objectClass -eq "group") {
                        get-adgroupmember $i -recursive |% {get-aduser $_.name}
                } else {
                        get-aduser $i
                }
        } | select-object -unique
}
}
