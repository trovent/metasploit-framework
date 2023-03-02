# -*- coding:binary -*-

require 'spec_helper'
require 'rex/proto/kerberos/pac/krb5_pac'

RSpec.describe Rex::Proto::Kerberos::Pac::Krb5Pac do
  subject(:pac) do
    described_class.new
  end

  let(:sample) do
    "\x04\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\xb0\x01\x00\x00" \
    "\x48\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x12\x00\x00\x00" \
    "\xf8\x01\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x14\x00\x00\x00" \
    "\x10\x02\x00\x00\x00\x00\x00\x00\x07\x00\x00\x00\x14\x00\x00\x00" \
    "\x28\x02\x00\x00\x00\x00\x00\x00\x01\x10\x08\x00\xcc\xcc\xcc\xcc" \
    "\xa0\x01\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x1e\x7c\x42" \
    "\xfc\x18\xd0\x01\xff\xff\xff\xff\xff\xff\xff\x7f\xff\xff\xff\xff" \
    "\xff\xff\xff\x7f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\xff\xff\xff\xff\xff\xff\xff\x7f\x08\x00\x08\x00" \
    "\x02\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00" \
    "\x04\x00\x00\x00\x00\x00\x00\x00\x05\x00\x00\x00\x00\x00\x00\x00" \
    "\x06\x00\x00\x00\x00\x00\x00\x00\x07\x00\x00\x00\x00\x00\x00\x00" \
    "\xe8\x03\x00\x00\x01\x02\x00\x00\x05\x00\x00\x00\x08\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x09\x00\x00\x00\x14\x00\x14\x00" \
    "\x0a\x00\x00\x00\x0b\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x10\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00" \
    "\x6a\x00\x75\x00\x61\x00\x6e\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x05\x00\x00\x00\x01\x02\x00\x00\x07\x00\x00\x00" \
    "\x00\x02\x00\x00\x07\x00\x00\x00\x08\x02\x00\x00\x07\x00\x00\x00" \
    "\x06\x02\x00\x00\x07\x00\x00\x00\x07\x02\x00\x00\x07\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00" \
    "\x00\x00\x00\x00\x0a\x00\x00\x00\x44\x00\x45\x00\x4d\x00\x4f\x00" \
    "\x2e\x00\x4c\x00\x4f\x00\x43\x00\x41\x00\x4c\x00\x04\x00\x00\x00" \
    "\x01\x04\x00\x00\x00\x00\x00\x05\x15\x00\x00\x00\x03\x99\xa8\x68" \
    "\xe0\x0e\x0e\xd9\x9a\x18\xcf\xcf\x00\x1e\x7c\x42\xfc\x18\xd0\x01" \
    "\x08\x00\x6a\x00\x75\x00\x61\x00\x6e\x00\x00\x00\x00\x00\x00\x00" \
    "\x07\x00\x00\x00\xf5\xb5\xdf\xc1\x14\xdd\x8e\x42\x8c\xfd\x09\x34" \
    "\xdc\x4e\x38\xcb\x00\x00\x00\x00\x07\x00\x00\x00\x07\xeb\x33\x91" \
    "\xc5\xd1\x21\x15\x32\x26\x92\x19\x5f\x02\x3e\x6c\x00\x00\x00\x00"
  end

  let(:rsa_md5) { 7 }

  describe '#assign' do
    let(:logon_info) do
      validation_info = Rex::Proto::Kerberos::Pac::Krb5ValidationInfo.new
      validation_info.logon_time = Time.at(1418712492)
      validation_info.effective_name = 'juan'
      validation_info.user_id = 1000
      validation_info.primary_group_id = 513
      validation_info.group_ids = [513, 512, 520, 518, 519]
      validation_info.logon_domain_name = 'DEMO.LOCAL'
      validation_info.logon_domain_id = 'S-1-5-21-1755879683-3641577184-3486455962'
      validation_info.full_name = ''
      validation_info.logon_script = ''
      validation_info.profile_path = ''
      validation_info.home_directory = ''
      validation_info.home_directory_drive = ''
      validation_info.logon_server = ''
      Rex::Proto::Kerberos::Pac::Krb5LogonInformation.new(
        data: validation_info
      )
    end

    let(:client_info) do
      Rex::Proto::Kerberos::Pac::Krb5ClientInfo.new(
        client_id: Time.at(1418712492),
        name: 'juan'
      )
    end

    let(:server_checksum) do
      Rex::Proto::Kerberos::Pac::Krb5PacServerChecksum.new(
        signature_type: rsa_md5
      )
    end

    let(:priv_srv_checksum) do
      Rex::Proto::Kerberos::Pac::Krb5PacPrivServerChecksum.new(
        signature_type: rsa_md5
      )
    end

    let(:pac_elements) do
      [
        logon_info,
        client_info,
        server_checksum,
        priv_srv_checksum
      ]
    end

    it 'creates a valid pac structure' do
      pac.assign(pac_elements: pac_elements)
      pac.sign!
      expect(pac).to eq(described_class.read(sample))
    end

    it 'the binary is equivalent' do
      pac.assign(pac_elements: pac_elements)
      pac.sign!
      expect(pac.to_binary_s).to eq(sample)
    end
  end

  describe '#read' do
    it 'correctly parses the binary data' do
      pac = described_class.read(sample)
      expect(pac.to_binary_s).to eq(sample)
    end
  end
end

RSpec.describe Rex::Proto::Kerberos::Pac::Krb5LogonInformation do
  subject(:logon_info) do
    described_class.new
  end

  let(:sample) do
    "\x01\x10\x08\x00\xcc\xcc\xcc\xcc\xa0\x01\x00\x00\x00\x00\x00\x00" \
    "\x01\x00\x00\x00\x00\x1e\x7c\x42\xfc\x18\xd0\x01\xff\xff\xff\xff" \
    "\xff\xff\xff\x7f\xff\xff\xff\xff\xff\xff\xff\x7f\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff\xff" \
    "\xff\xff\xff\x7f\x08\x00\x08\x00\x02\x00\x00\x00\x00\x00\x00\x00" \
    "\x03\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00" \
    "\x05\x00\x00\x00\x00\x00\x00\x00\x06\x00\x00\x00\x00\x00\x00\x00" \
    "\x07\x00\x00\x00\x00\x00\x00\x00\xe8\x03\x00\x00\x01\x02\x00\x00" \
    "\x05\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x09\x00\x00\x00\x14\x00\x14\x00\x0a\x00\x00\x00\x0b\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x10\x02\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00" \
    "\x00\x00\x00\x00\x04\x00\x00\x00\x6a\x00\x75\x00\x61\x00\x6e\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05\x00\x00\x00" \
    "\x01\x02\x00\x00\x07\x00\x00\x00\x00\x02\x00\x00\x07\x00\x00\x00" \
    "\x08\x02\x00\x00\x07\x00\x00\x00\x06\x02\x00\x00\x07\x00\x00\x00" \
    "\x07\x02\x00\x00\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" \
    "\x00\x00\x00\x00\x0a\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00" \
    "\x44\x00\x45\x00\x4d\x00\x4f\x00\x2e\x00\x4c\x00\x4f\x00\x43\x00" \
    "\x41\x00\x4c\x00\x04\x00\x00\x00\x01\x04\x00\x00\x00\x00\x00\x05" \
    "\x15\x00\x00\x00\x03\x99\xa8\x68\xe0\x0e\x0e\xd9\x9a\x18\xcf\xcf"
  end

  describe '#read' do
    it 'correctly parses the binary data' do
      valid_info = described_class.read(sample)
      expect(valid_info.to_binary_s).to eq(sample)
    end
  end

  it 'creates a valid logon info structure' do
    valid_info = Rex::Proto::Kerberos::Pac::Krb5ValidationInfo.new
    valid_info.logon_time = Time.at(1418712492)
    valid_info.effective_name = 'juan'
    valid_info.user_id = 1000
    valid_info.primary_group_id = 513
    valid_info.group_ids = [513, 512, 520, 518, 519]
    valid_info.logon_domain_name = 'DEMO.LOCAL'
    valid_info.logon_domain_id = 'S-1-5-21-1755879683-3641577184-3486455962'
    valid_info.full_name = ''
    valid_info.logon_script = ''
    valid_info.profile_path = ''
    valid_info.home_directory = ''
    valid_info.home_directory_drive = ''
    valid_info.logon_server = ''

    logon_info.data = valid_info

    read_logon_info = described_class.read(sample)
    expect(logon_info).to eq(read_logon_info)
  end
end

RSpec.describe Rex::Proto::Kerberos::Pac::Krb5ClientInfo do
  subject(:client_info) do
    described_class.new
  end

  let(:sample) do
    "\x80\x60\x06\x1b\xbe\x18\xd0\x01\x08\x00\x6a\x00\x75\x00\x61\x00\x6e\x00"
  end

  describe '#read' do
    it 'correctly parses the binary data' do
      client_info = described_class.read(sample)
      expect(client_info.to_binary_s).to eq(sample)
    end
  end

  it 'creates a valid client info structure' do
    client_info.client_id = Time.new(2014, 12, 15, 23, 23, 17, '+00:00')
    client_info.name = 'juan'

    parsed_client_info = described_class.read(sample)
    expect(client_info).to eq(parsed_client_info)
  end
end

RSpec.describe Rex::Proto::Kerberos::Pac::Krb5PacCredentialInfo do
  subject(:credential_info) do
    described_class.new(data_length: data_length)
  end

  let(:data_length) { sample.size }

  let(:sample) do
    "\x00\x00\x00\x00\x12\x00\x00\x00\x53\xc8\x0e\x1a\x5d\x54\xf3\xb4\x82\x7d"\
    "\x72\xf1\xba\x76\x2d\xf9\x74\xcc\x08\x7e\xf7\x47\x80\x1a\x03\x05\xfb\x3e"\
    "\xe0\xe3\x5c\x42\xe7\x9e\xc7\xbd\xd3\xa6\x7c\x2a\x6b\x6e\x11\x6c\x5d\xdc"\
    "\x30\x3f\xb4\x45\x23\x4b\x0b\x09\x2b\x5f\x72\xee\xf1\xf1\xeb\x07\xd7\xbc"\
    "\x91\x70\xf2\x9d\x2a\x61\xef\xa2\xa0\x64\x81\x99\xa1\xfc\xd4\xa1\x73\xcb"\
    "\x7b\x99\x7c\x16\xb5\xa6\xbd\x26\x64\x63\xce\x05\xf3\x80\xcc\xdb\xd2\x48"\
    "\xf7\x06\xe2\xd0\x21\x4b\x87\x42\x8c\x5f\xe3\x98\xbb\x05\x27\x09\x7b\xe7"\
    "\x8b\xa1\xfa\xaa\xbd\x06\x37\x5c\x21\x78\x42\x2a\x18\xe8\xce\x6d\x9e\x64"\
    "\xb2\xc8\x42\x83"
  end

  describe '#read' do
    let(:data_length) { sample.size }

    it 'correctly parses the binary data' do
      credential_info.read(sample)
      expect(credential_info.to_binary_s).to eq(sample)
    end
  end


  it 'creates a valid credential info structure' do
    credential_info.version = 0
    credential_info.encryption_type = 18
    credential_info.serialized_data = sample[8..].bytes

    parsed_credential_info = described_class.new(data_length: sample.size)
    parsed_credential_info.read(sample)
    expect(credential_info).to eq(parsed_credential_info)
  end

  describe '#decrypt_serialized_data' do
    subject(:decrypted_serialized_data) do
      credential_info.read(sample)
      credential_info.decrypt_serialized_data(key)
    end

    let(:credential_data) do
      Rex::Proto::Kerberos::Pac::Krb5SerializedPacCredentialData.new(
        common_header: {
          version: 1,
          endianness: 16,
          common_header_length: 8,
          filler: 0xCCCCCCCC
        },
        private_header1: {
          object_buffer_length: 96,
          filler: 0x00000000
        },
        data: Rex::Proto::Kerberos::Pac::Krb5PacCredentialData.new(
          credential_count: 1,
          credentials: [
            Rex::Proto::Kerberos::Pac::Krb5SecpkgSupplementalCred.new(
              package_name: 'NTLM',
              credential_size: 40,
              credentials: [
                0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                0, 0, 0, 0, 0, 169, 61, 22, 135, 60, 157, 73, 190, 155,
                27, 206, 67, 89, 220, 170, 109
              ]
            )
          ]
        )
      )
    end

    let(:key) do
      "\x48\xa7\x4a\x36\xd6\x48\xa8\x74\x24\x68\x69\x32\x08\x8a\xf8\x1c\x51\x3c"\
      "\x7f\x5b\x3b\x64\x01\x34\x63\xc5\xff\x90\x03\x4d\xeb\x86"
    end

    it 'returns the expected Krb5SerializedPacCredentialData structure' do
      expect(decrypted_serialized_data).to eq(credential_data)
    end

    context 'containing a NTLM_SUPPLEMENTAL_CREDENTIAL structure' do
      let(:ntlm) { 'aad3b435b51404eeaad3b435b51404ee:a93d16873c9d49be9b1bce4359dcaa6d' }
      it 'extracts the NTLM hash' do
        expect(decrypted_serialized_data.data.extract_ntlm_hash).to eq(ntlm)
      end
    end
  end
end

RSpec.describe Rex::Proto::Kerberos::Pac::Krb5UpnDnsInfo do
  let(:upn) { 'test@windomain.local' }
  let(:dns_domain_name) { 'WINDOMAIN.LOCAL' }
  let(:sam_name) { 'test' }
  let(:sid) { 'S-1-5-32-544' }

  let(:sample) do
    "\x28\x00\x10\x00\x1e\x00\x38\x00\x01\x00\x00\x00\x00\x00\x00\x00" \
    "\x74\x00\x65\x00\x73\x00\x74\x00\x40\x00\x77\x00\x69\x00\x6e\x00" \
    "\x64\x00\x6f\x00\x6d\x00\x61\x00\x69\x00\x6e\x00\x2e\x00\x6c\x00" \
    "\x6f\x00\x63\x00\x61\x00\x6c\x00\x57\x00\x49\x00\x4e\x00\x44\x00" \
    "\x4f\x00\x4d\x00\x41\x00\x49\x00\x4e\x00\x2e\x00\x4c\x00\x4f\x00" \
    "\x43\x00\x41\x00\x4c\x00"
  end

  let(:sample_ext) do
    "\x28\x00\x18\x00\x1e\x00\x40\x00\x02\x00\x00\x00\x08\x00\x5e\x00" \
    "\x10\x00\x66\x00\x00\x00\x00\x00\x74\x00\x65\x00\x73\x00\x74\x00" \
    "\x40\x00\x77\x00\x69\x00\x6e\x00\x64\x00\x6f\x00\x6d\x00\x61\x00" \
    "\x69\x00\x6e\x00\x2e\x00\x6c\x00\x6f\x00\x63\x00\x61\x00\x6c\x00" \
    "\x57\x00\x49\x00\x4e\x00\x44\x00\x4f\x00\x4d\x00\x41\x00\x49\x00" \
    "\x4e\x00\x2e\x00\x4c\x00\x4f\x00\x43\x00\x41\x00\x4c\x00\x74\x00" \
    "\x65\x00\x73\x00\x74\x00\x01\x02\x00\x00\x00\x00\x00\x05\x20\x00" \
    "\x00\x00\x20\x02\x00\x00"
  end

  context 'with non-extended upn dns info' do
    describe '#read' do
      it 'correctly parses the binary data' do
        upn_dns_info = described_class.read(sample)
        expect(upn_dns_info.to_binary_s).to eq(sample)
      end

      it 'creates a valid upn dns info structure' do
        upn_dns_info = described_class.new(
          upn: upn,
          dns_domain_name: dns_domain_name,
          flags: 1
        )

        upn_dns_info.set_offsets!

        parsed_sample = described_class.read(sample)
        expect(upn_dns_info).to eq(parsed_sample)
      end

      it 'ignores sam/sid values if set' do
        upn_dns_info = described_class.new(
          upn: upn,
          dns_domain_name: dns_domain_name,
          sam_name: sam_name,
          sid: sid,
          flags: 1
        )
        upn_dns_info.set_offsets!

        parsed_sample = described_class.read(sample)
        expect(upn_dns_info).to eq(parsed_sample)
      end
    end

    describe '#write' do
      it 'outputs the expected binary representation' do
        upn_dns_info = described_class.new(
          upn: upn,
          dns_domain_name: dns_domain_name,
          flags: 1
        )
        upn_dns_info.set_offsets!

        binary = upn_dns_info.to_binary_s
        expect(binary).to eq(sample)
      end

      it 'ignores sam/sid values if set' do
        upn_dns_info = described_class.new(
          upn: upn,
          dns_domain_name: dns_domain_name,
          sam_name: sam_name,
          sid: sid,
          flags: 1
        )
        upn_dns_info.set_offsets!

        binary = upn_dns_info.to_binary_s
        expect(binary).to eq(sample)
      end
    end
  end

  context 'with extended upn dns info' do
    describe '#read' do
      it 'correctly parses the binary data' do
        upn_dns_info = described_class.read(sample_ext)
        expect(upn_dns_info.to_binary_s).to eq(sample_ext)
      end

      it 'creates a valid upn dns info structure' do
        upn_dns_info = described_class.new(
          upn: upn,
          dns_domain_name: dns_domain_name,
          sam_name: sam_name,
          sid: sid,
          flags: 2
        )
        upn_dns_info.set_offsets!

        parsed_sample = described_class.read(sample_ext)
        expect(upn_dns_info).to eq(parsed_sample)
      end
    end

    describe '#write' do
      it 'outputs the expected binary representation' do
        upn_dns_info = described_class.new(
          upn: upn,
          dns_domain_name: dns_domain_name,
          sam_name: sam_name,
          sid: sid,
          flags: 2
        )
        upn_dns_info.set_offsets!

        binary = upn_dns_info.to_binary_s
        expect(binary).to eq(sample_ext)
      end
    end
  end
end
