// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockMed {
    struct Prescription {
        uint256 id;
        address doctor;
        string patientHash;
        string ipfsHash;
        uint256 timestamp;
        bool verified;
    }

    mapping(uint256 => Prescription) public prescriptions;
    uint256 public prescriptionCount;

    event PrescriptionAdded(uint256 id, address doctor, string ipfsHash);
    event PrescriptionVerified(uint256 id);

    function addPrescription(string memory _patientHash, string memory _ipfsHash) public {
        prescriptionCount++;
        prescriptions[prescriptionCount] = Prescription(
            prescriptionCount,
            msg.sender,
            _patientHash,
            _ipfsHash,
            block.timestamp,
            false
        );
        emit PrescriptionAdded(prescriptionCount, msg.sender, _ipfsHash);
    }

    function verifyPrescription(uint256 _id) public {
        prescriptions[_id].verified = true;
        emit PrescriptionVerified(_id);
    }

    function getPrescription(uint256 _id) public view returns (Prescription memory) {
        return prescriptions[_id];
    }
}

