
# Atividade sobre AWS e Linux.
# Requisitos : AWS
- Gerar uma chave pública para acesso ao ambiente;
- Criar 1 instância EC2 com o sistema operacional Amazon Linux 2 (Família t3.small, 16 GB SSD);
- Gerar 1 elastic IP e anexar à instância EC2;
- Liberar as portas de comunicação para acesso público: (22/TCP, 111/TCP e UDP, 2049/TCP/UDP, 80/TCP, 443/TCP).

# Requisitos no linux
- Configurar o NFS entregue;
- Criar um diretorio dentro do filesystem do NFS com seu nome;
- Subir um apache no servidor - o apache deve estar online e rodando;
- Criar um script que valide se o serviço esta online e envie o resultado da validação para o seu diretorio no nfs;
- O script deve conter - Data HORA + nome do serviço + Status + mensagem personalizada de ONLINE ou offline;
- O script deve gerar 2 arquivos de saida: 1 para o serviço online e 1 para o serviço OFFLINE;
- Preparar a execução automatizada do script a cada 5 minutos.
- Fazer o versionamento da atividade;
- Fazer a documentação explicando o processo de instalação do Linux.

# Documentação do processo de instalação do Linux na AWS.

# Sumario

1. [Criação de uma VPC](#criação-de-uma-vpc)
2. [Criação de um grupo de segurança](#criação-de-um-grupo-de-segurança)
3. [Criar par de chaves](#criar-par-de-chaves)
4. [Criação da instância Linux](#criação-da-instância-linux)
5. [Atribuindo um endereço IP elástico](#atribuindo-um-endereço-ip-elástico)


## Criação de uma **[*VPC*](https://aws.amazon.com/pt/vpc/)**

Uma nuvem privada virtual (VPC) é uma rede virtual dedicada à sua conta da AWS. Ela é isolada de maneira lógica de outras redes virtuais na Nuvem da AWS.

Para realizar a criação de sua VPC siga os seguintes passos:

1. Acesse o serviço VPC pelo console da AWS. (https://console.aws.amazon.com/vpc/)
2. Clique em suas VPCs. 
3. Clique em criar VPC.
4. Preencha os campos da seguinte forma:
Nome
```
Erik
```
CIDR IPv4
```
10.0.0.0/24
```
TAGS
| Chave | Valor  |
| ---     | ---   |
|Project|PB|
|CostCenter|PBCompass|


6. Clique em criar VPC.

### **[*Sub-redes*](https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/configure-subnets.html)**

Uma sub-rede é uma gama de endereços IP na VPC. Você pode iniciar recursos da AWS em uma sub-rede especificada.

Para realizar a criação de sua sub-rede siga os seguintes passos:

1. Clique em sub-redes.
2. Clique em criar sub-rede.
3. Em ID da VPC selecione sua VPC criada anteriormente.
4. Após a seleção da VPC ira aparecer uma area de configuração para sua sub-rede.
5. Preencha da seguinte forma:

Nome
```
Erik
```
Zona de disponibilidade

```
us-east-1a
```
CIDR IPv4
```
10.0.0.0/24
```
TAGS
| Chave | Valor  |
| ---     | ---   |
|Project|PB|
|CostCenter|PBCompass|

6. Clique em criar sub-rede.

### **[*Gateways da internet*](https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/VPC_Internet_Gateway.html)**
Um gateway da Internet é um roteador virtual que conecta uma VPC à Internet.

Para realizar a criação de seu Gateway da internet siga os seguintes passos:
1. Clique em Gateways da internet.
2. Clique em criar Gateways da internet.
3. Preencha os campos da seguite forma.

Nome
```
ErikGateway
```
TAGS
| Chave | Valor  |
| ---     | ---   |
|Project|PB|
|CostCenter|PBCompass|

4. Clique em criar Gateway de internet.

### **[*Tabelas de rotas*](https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/VPC_Route_Tables.html)**

Uma tabela de rotas contém um conjunto de regras, chamado rotas, usadas para determinar para onde o tráfego de rede de sua sub-rede ou gateway é direcionado.

Para realizar a criação de sua tabela de rotas.

1. Clique em tabelas de rotas.
2. Clique em criar tabela de rotas.
3. De um nome `Erik` para sua tabela de rotas.
4. No campo `VPC` selecione sua VPC criada anteriormente.
5. Clique em criar tabela de rotas.

Após realizar esses passos utilizaremos a tabela de rotas para conectar o Gateway da internet e sua Sub-rede.

Selecione a tabela de rotas com o nome `Erik`. Após selecionar ela, estará visível no canto inferior às configurações referente a essa tabela.
1. Clique em rotas;
2. Clique em editar rotas;
3. Na página de edição clique em adicionar rota;
4. Preencha os campos da seguinte forma:

| Destino | Alvo  |
| ---     | ---   |
|0.0.0.0/0|Seu gateways da internet|

5. Clique em salvar alterações

Retornando ao setor de configurações da tabela de rotas realize os seguintes passos:

1. Clique em Associações de sub-rede;
2. siga até Sub-redes sem associações explícitas;
3. Caso sua sub-rede já esteja amostra, a configuração acabou;
4. Caso contrário, vá em associações explícitas de sub-rede e adicione a sub-rede que falta. 

Após a realização desses passos, nossa sub-rede criada terá acesso à internet. Agora podemos dar início a construção de nossa instância linux.

## Criação de um **[*grupo de segurança*](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/ec2-security-groups.html)**

Um grupo de segurança atua como um firewall virtual que controla o tráfego de uma ou mais instâncias.

Para a criação do grupo de segurança siga os seguintes passos:

1. Acesse o serviço Ec2 pelo console da AWS; https://us-east-1.console.aws.amazon.com/ec2
2. Clique em Grupos de segurança;
3. Clique em criar grupo de segurança;
4. Preencha os campos da seguinte forma:

Nome
```
ErikSeguranca
```
VPC

```
Sua VPC criada anteriomente
```

Regras de entrada

![segurança](segurança.png)

Na porta SSH foi utilizado meu IP. Você pode obter seu IP pelo site https://meuip.com.br.

TAGS
| Chave | Valor  |
| ---     | ---   |
|Project|PB|
|CostCenter|PBCompass|

5. Clique em criar grupo de segurança.

## Criar **[*par de chaves*](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/ec2-key-pairs.html)**

Um par de chaves, que consiste em uma chave privada e uma chave pública, é um conjunto de credenciais de segurança que você usa para provar sua identidade ao se conectar a uma instância.

Para criar o par de chaves siga os seguintes passas:

1. No tópico rede e segurança clique em pares de chaves;
2. Clique em criar par de chaves;
3. Preencha os campos da seguinte forma:

Nome
```
ChaveErik
```
Tipo de par de chaves
```
RSA
```
Formato de arquivo de chave privada
```
.ppk
```
OBS. O formato da chave é específico para como você irá acessar a instância, no meu caso será pelo putty no sistema operacional windows.

TAGS
| Chave | Valor  |
| ---     | ---   |
|Project|PB|
|CostCenter|PBCompass|

4. Clique em criar par de chaves.


## Criação da **[*instância*](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/EC2_GetStarted.html)** Linux

Agora que já possuímos as configurações necessárias para criar nossa instância.
Siga os seguintes passos:

1. clique em instâcias no console de serviços ec2;
2. Clique em executar instâncias;
3. Agora preencha os campos da seguinte forma:

| Chave | Valor  |
| ---     | ---   |
|Name|Erik|
|Project|PB|
|CostCenter|PBCompass|

Imagens de aplicação e de sistema operacional

```
Amazon Linux 2 AMI
```

Tipo de instância

```
t3.small
```
Nome do par de chaves
```
ChaveErik
```
Nome do par de chaves

Configurações de rede

Clique em editar 
1. Selecione sua VPC;
2. Selecione sua sub-rede;
3. Habilite o IP público;
4. Em Firewall (grupos de segurança) selecione grupo de segurança existente.

Grupos de segurança
```
ErikSeguranca
```

Configurar armazenamento

Aumente a capacidade do SSD para 16 Gib
Por fim, selecione o botão Executar Instância.
Com isso, finalizamos a construção de nossa instância.

A instância já está disponível para utilização.

## Atribuindo um endereço **[*IP elástico*](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html)**

Um Endereço IP elástico é um endereço IPv4 estático projetado para computação em nuvem dinâmica.

Para atribuir um IP elástico siga os seguintes passos:


1. No console do serviço ec2 na parte de rede e segurança clique em IPs elásticos;
2. Clique em alocar endereço IP elástico;
3. Preencha os campos da seguinte forma:

Grupo de Borda de Rede
```
us-east-1
```
TAGS

| Chave | Valor  |
| ---     | ---   |
|Name|Erik|
|Project|PB|
|CostCenter|PBCompass|

4. Clique em alocar.

Após a criação do IP elástico, o próximo passo é associar esse IP a nossa instância.
1. Selecione seu IP elástico;
2. Clique em associar endereço IP elástico;
3. Em tipo de recurso selecione instância;
4. Em instância selecione sua instância;
5. No endereço IP privado selecione o IP de sua instância;
6. Por fim, clique em associar.

Após a execução desses passos você terá sua instância associada a um IP elástico.