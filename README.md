
# Atividade sobre AWS e Linux.
Erik Alexandre Bezerra
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

# sumário

1. [Criar par de chaves](#criar-par-de-chaves)
2. [Criação da instância Linux](#criação-da-instância-linux)
3. [Atribuindo um endereço IP elástico](#atribuindo-um-endereço-ip-elástico)
4. [Configuração de um grupo de segurança](#configuração-do-grupo-de-segurança)

# Criar **[*par de chaves*](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/ec2-key-pairs.html)**

Um par de chaves, que consiste em uma chave privada e uma chave pública, é um conjunto de credenciais de segurança que você usa para provar sua identidade ao se conectar a uma instância.

Para criar o par de chaves siga os seguintes passas:

1. Acesse o serviço Ec2 pelo console da AWS por meio do link https://us-east-1.console.aws.amazon.com/ec2; 
2. No tópico rede e segurança clique em `pares de chaves`;
3. Clique em `criar par de chaves`;
4. Preencha os campos da seguinte forma:

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
.pem
```
OBS. O formato da chave é específico para como você irá acessar a instância, no meu caso será pelo cmd no sistema operacional windows.

TAGS
| Chave | Valor  |
| ---     | ---   |
|Project|PB|
|CostCenter|PBCompass|

5. Clique em `criar par de chaves`.

# Criação da **[*instância*](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/EC2_GetStarted.html)** Linux
É possível executar uma instância do Linux utilizando o AWS Management Console como descrito no procedimento a seguir.

1. Acesse o console de serviços ec2;
2. Clique em `instâcias`;
3. Clique em `executar instâncias`;
4. Agora preencha os campos da seguinte forma:

TAGS
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


### Configurações de rede
 
Em Firewall (grupos de segurança) selecione grupo de segurança existente.

Grupos de segurança
```
Default
```

### Configurar armazenamento

Aumente a capacidade do SSD para 16 Gib. 
Por fim, clique no botão Executar Instância.
Com isso, finalizamos a construção de nossa instância.



# Atribuindo um endereço **[*IP elástico*](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html)**

Um Endereço IP elástico é um endereço IPv4 estático projetado para computação em nuvem dinâmica.

Para atribuir um IP elástico siga os seguintes passos:


1. No console do serviço ec2 na parte de rede e segurança clique em `IPs elásticos`;
2. Clique em `alocar endereço IP elástico`;
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

4. Clique em `alocar`.

Após a criação do IP elástico, o próximo passo é associar esse IP a nossa instância.
1. Selecione seu IP elástico;
2. Clique em `associar endereço IP elástico`;
3. Em tipo de recurso selecione instância;
4. Em instância selecione o Id de sua instância;
5. No endereço IP privado selecione o IP de sua instância;
6. Por fim, clique em `associar`.

Após a execução desses passos você terá sua instância associada a um IP elástico.

```
Ao tentar se conectar à instância não obtive sucesso. 
Ao analisar a VPC e suas sub-redes notei que estava faltando criar um gateway de internet. 

```

# **[*Gateways da internet*](https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/VPC_Internet_Gateway.html)**
Um gateway da Internet é um roteador virtual que conecta uma VPC à Internet.

Para realizar a criação de seu Gateway da internet siga os seguintes passos:
1. Acesse o console do serviço de VPC por meio do link https://us-east-1.console.aws.amazon.com/vpc/;
1. Clique em `Gateways da internet`.
2. Clique em `criar Gateways da internet`.
3. Preencha os campos da seguite forma.

Nome
```
GatewayErik
```
TAGS
| Chave | Valor  |
| ---     | ---   |
|Project|PB|
|CostCenter|PBCompass|

5. Clique em `criar Gateway de internet`.

# Configuração da **[*Tabelas de rotas*](https://docs.aws.amazon.com/pt_br/vpc/latest/userguide/VPC_Route_Tables.html)**
Uma tabela de rotas contém um conjunto de regras, chamado rotas, usadas para determinar para onde o tráfego de rede de sua sub-rede ou gateway é direcionado.

Para realizar a Configuração de sua tabela de rotas.

1. Clique em `tabelas de rotas`;
2. Selecione a tabela de rotas de sua sub-rede;
3. Clique em `ações` e selecione editar rotas;
4. Na página de edição clique em `adicionar rota`;
5. Preencha os campos da seguinte forma:

| Destino | Alvo  |
| ---     | ---   |
|0.0.0.0/0|GatewayErik|

6. Clique em `salvar alterações`

```
Ao realizar essas configurações consegui acessar a instância normalmente.
```
# Configuração do **[*grupo de segurança*](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/ec2-security-groups.html)**

Um grupo de segurança atua como um firewall virtual que controla o tráfego de uma ou mais instâncias.

Para realizar a configuração do grupo de segurança siga os seguintes passos:

1. Acesse o serviço Ec2 pelo console da AWS por meio do link https://us-east-1.console.aws.amazon.com/ec2;
2. Clique em `Grupos de segurança`;
3. Selecione seu grupo de segurança default;
4. Clique em `ações` e selecione editar regras de entrada;
4. Preencha os campos da seguinte forma:

Regras de entrada

![segurança](segurança.png)

Na porta SSH foi utilizado meu IP. Você pode obter seu IP pelo site https://meuip.com.br.

6. Clique em `salvar`.

Após realizar todas as configurações podemos acessar a nossa instância via SSH usando o seguinte comando:

ssh -i ChaveErik.pem ec2-user@(Ip da instâcia)


Para que a instância fique pronta para ser utilizada use os seguintes comandos: 
```
sudo su
yum -y update 
```
E com isso finalizamos a instalação do Linux na AWS.