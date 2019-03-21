# utility function to fill up /var/ossec/etc/client.keys
define ossec::agentkey(
  $agent_id,
  $agent_name,
  $agent_ip_address,
  $agent_seed = 'xaeS7ahf',
) {
  if ! $agent_id { fail("ossec::agentkey: ${agentId} is missing")}

  $agentKey1 = ossec_md5("${agent_id} ${agent_seed}")
  $agentKey2 = ossec_md5("${agent_name} ${agent_ip_address} ${agent_seed}")

  concat::fragment { "var_ossec_etc_client.keys_${agent_ip_address}_part":
    target  => '/var/ossec/etc/client.keys',
    order   => $agentId,
    content => "${agent_id} ${agent_name} ${agent_ip_address} ${agentKey1}${agentKey2}\n",
  }

}
