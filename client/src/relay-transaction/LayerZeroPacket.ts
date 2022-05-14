// To parse this data:
//
//   import { Convert, LayerZeroPacket } from "./file";
//
//   const layerZeroPacket = Convert.toLayerZeroPacket(json);

export interface LayerZeroPacket {
    abi: Abi[];
}

export interface Abi {
    inputs:          Input[];
    name:            string;
    outputs:         Input[];
    stateMutability: string;
    type:            string;
}

export interface Input {
    internalType: string;
    name:         string;
    type:         string;
    components?:  Input[];
}

// Converts JSON strings to/from your types
export class Convert {
    public static toLayerZeroPacket(json: string): LayerZeroPacket {
        return JSON.parse(json);
    }

    public static layerZeroPacketToJson(value: LayerZeroPacket): string {
        return JSON.stringify(value);
    }

    public static toAbi(json: string): Abi {
        return JSON.parse(json);
    }

    public static abiToJson(value: Abi): string {
        return JSON.stringify(value);
    }

    public static toInput(json: string): Input {
        return JSON.parse(json);
    }

    public static inputToJson(value: Input): string {
        return JSON.stringify(value);
    }
}
