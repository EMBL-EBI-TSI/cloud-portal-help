# Docker container

## OpenStack (extcloud03)

Key | Value
--- | :---
`docker_repository`		| `nginx`
`docker_port_expose`		| `80`
`docker_port_map`		| `8080`
`network_name`			| `TSI-network`
`floatingip_pool`		| `net_external`
`machine_type`			| `s1.modest`
`disk_image`			| `coreos-stable`
`public_key_path`		| `~/.ssh/demo-key.pub`
`private_key_path`		| `~/.ssh/demo-key`
`ssh_key`			| `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQrspqAaGuwFJVB07qymRwXPlHx8oT5ahkeejHPIDNwDr1hWUIsC9Hfrq1Y1ya2Uc8WmJH4zSjgygtaGeiE+FZgQOiNcsR/AG8da6LywReP9Q47oImXVs/CQMmB9z74T9qtQiuaJd5OVVzhKebavDhUh15WBt9BjlHIEkpZP0qpPtI8z1IwFjHV4MFrP2tbKqNYh3zNU70d8iDIdAyUuBOmzg+k1Az/hR+T4O/7aiVTgksuRBMufYyIhECpGCY1U0JlQg7navD/JXXI3u5q7UYs+/DevjYGwqEnOisTjZoMkNGF09CUU0+DbTsh5+Hc0ncYHasdC8dscKLfAt7wFc3fvXQue3aDJn8oqGEGbJ2AHXXjO5/33wlaPotJqJt3SiQeE2L4TYEnaAQmVhI9/M9Ex0wW0OrZkkqnXEEdFm+Psgopj38hNsEv4wlMSkubEiUGGrYYz5AVixZNJnGpGLvPg/oa66v1AGZT6LGD8JR6jnlHsZf3SPhhenBXN/L6ieLJa4x7xQptpXh7BJYwrx8ZmUEs37+XoF57+5jEk4XMFO7zhmQHvpZPDSjyBGluSvjHVDJ67Krm9bh7VuqJ+FuYRl1TxSwTSYOOFSpbqO1g6cWspYudjlin5Rh9bMZXeEj0XvdAFo1+6BqRJl7VHMcgGMmUTx5oPV737GyITX7iw== tsi-group@ebi.ac.uk`


## OpenStack (extcloud05)

Key | Value
--- | :---
`floatingip_pool`		| `ext-net`
`machine_type`			| `s1.modest`
`disk_image`			|
`network_name`			| `test_network`
`docker_repository`		| `nginx`
`docker_port_expose`		| `80`
`docker_port_map`		| `8080`
`public_key_path`		| `~/.ssh/demo-key.pub`
`private_key_path`		| `~/.ssh/demo-key`
`ssh_key`			| `ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDQrspqAaGuwFJVB07qymRwXPlHx8oT5ahkeejHPIDNwDr1hWUIsC9Hfrq1Y1ya2Uc8WmJH4zSjgygtaGeiE+FZgQOiNcsR/AG8da6LywReP9Q47oImXVs/CQMmB9z74T9qtQiuaJd5OVVzhKebavDhUh15WBt9BjlHIEkpZP0qpPtI8z1IwFjHV4MFrP2tbKqNYh3zNU70d8iDIdAyUuBOmzg+k1Az/hR+T4O/7aiVTgksuRBMufYyIhECpGCY1U0JlQg7navD/JXXI3u5q7UYs+/DevjYGwqEnOisTjZoMkNGF09CUU0+DbTsh5+Hc0ncYHasdC8dscKLfAt7wFc3fvXQue3aDJn8oqGEGbJ2AHXXjO5/33wlaPotJqJt3SiQeE2L4TYEnaAQmVhI9/M9Ex0wW0OrZkkqnXEEdFm+Psgopj38hNsEv4wlMSkubEiUGGrYYz5AVixZNJnGpGLvPg/oa66v1AGZT6LGD8JR6jnlHsZf3SPhhenBXN/L6ieLJa4x7xQptpXh7BJYwrx8ZmUEs37+XoF57+5jEk4XMFO7zhmQHvpZPDSjyBGluSvjHVDJ67Krm9bh7VuqJ+FuYRl1TxSwTSYOOFSpbqO1g6cWspYudjlin5Rh9bMZXeEj0XvdAFo1+6BqRJl7VHMcgGMmUTx5oPV737GyITX7iw== tsi-group@ebi.ac.uk`
