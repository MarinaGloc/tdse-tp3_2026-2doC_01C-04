{
  "graph": {
    "cells": [
      {
        "position": {
          "x": 0,
          "y": 0
        },
        "size": {
          "height": 10,
          "width": 10
        },
        "type": "Statechart",
        "id": "00ffb6d1-d225-4bc0-8b73-7df9987f57b7",
        "attrs": {
          "name": {
            "text": "task_display Export"
          },
          "specification": {
            "text": "@EventDriven\n@SuperSteps(no)\n\ninterface:\n    in event update\n    out event writeInstruction\n    out event writeData\n\n    var row: integer = 0\n    var column: integer = 0\n    var character: integer = 0\n    var flag: boolean = false\n    var lastOperation: string = \"NONE\""
          }
        },
        "z": 1
      },
      {
        "position": {
          "x": -448,
          "y": -255
        },
        "size": {
          "width": 835,
          "height": 485
        },
        "type": "Region",
        "attrs": {
          "priority": {
            "text": 1
          },
          "name": {
            "text": "task_display"
          }
        },
        "id": "ecbbc96e-feb3-4712-8c3c-e66e2177eb3a",
        "z": 19,
        "embeds": [
          "b913be20-387b-4126-83f6-cc46aec0a374",
          "c65353cc-bb54-4b9d-908b-1d16b59f0d2c",
          "e00fbb0f-a1c1-401d-94f9-465a28a0d7e5",
          "33cf84e7-ce66-4efc-8c45-88dd21302130",
          "19c847db-3c48-42bd-a1c4-4b3399a3e5e9",
          "add985a5-d6eb-4f70-add9-9123b5554d4d",
          "10c03158-ced1-4cda-a1a2-436b1d0c3f0d",
          "27d83f31-6f18-43b6-9e59-b9c390d22cda",
          "ab054825-2bb0-4b65-addf-7bc0bdeb9d9b"
        ]
      },
      {
        "position": {
          "x": -335,
          "y": -235
        },
        "size": {
          "height": 18,
          "width": 18
        },
        "type": "Entry",
        "entryKind": "Initial",
        "attrs": {},
        "id": "add985a5-d6eb-4f70-add9-9123b5554d4d",
        "z": 20,
        "parent": "ecbbc96e-feb3-4712-8c3c-e66e2177eb3a",
        "embeds": [
          "49234bdf-adb2-4f20-b998-6a54441e7a41"
        ]
      },
      {
        "position": {
          "x": -404,
          "y": -155
        },
        "size": {
          "width": 154,
          "height": 71
        },
        "type": "State",
        "attrs": {
          "name": {
            "text": "IDLE",
            "fontSize": 11
          },
          "specification": {
            "text": "entry / lastOperation = \"NONE\"  "
          }
        },
        "id": "10c03158-ced1-4cda-a1a2-436b1d0c3f0d",
        "z": 21,
        "parent": "ecbbc96e-feb3-4712-8c3c-e66e2177eb3a"
      },
      {
        "position": {
          "x": 49,
          "y": -173
        },
        "size": {
          "width": 164,
          "height": 96
        },
        "type": "State",
        "attrs": {
          "name": {
            "text": "SET_POSITION  ",
            "fontSize": 11
          },
          "specification": {
            "text": "entry / lastOperation = \"INSTRUCTION\"; raise writeInstruction"
          }
        },
        "id": "27d83f31-6f18-43b6-9e59-b9c390d22cda",
        "z": 23,
        "parent": "ecbbc96e-feb3-4712-8c3c-e66e2177eb3a"
      },
      {
        "position": {
          "x": 44,
          "y": 16
        },
        "size": {
          "width": 175,
          "height": 84
        },
        "type": "State",
        "attrs": {
          "name": {
            "text": "WRITE_CHARACTER",
            "fontSize": 11
          },
          "specification": {
            "text": "entry / character = column; lastOperation = \"DATA\"; raise writeData"
          }
        },
        "id": "ab054825-2bb0-4b65-addf-7bc0bdeb9d9b",
        "z": 25,
        "parent": "ecbbc96e-feb3-4712-8c3c-e66e2177eb3a",
        "embeds": [
          "c2e8106d-64a6-4677-a9d4-3bc933c7da20"
        ]
      },
      {
        "type": "NodeLabel",
        "label": true,
        "size": {
          "width": 15,
          "height": 15
        },
        "position": {
          "x": -335,
          "y": -220
        },
        "attrs": {
          "label": {
            "refX": "50%",
            "textAnchor": "middle",
            "refY": "50%",
            "textVerticalAnchor": "middle"
          }
        },
        "id": "49234bdf-adb2-4f20-b998-6a54441e7a41",
        "z": 29,
        "parent": "add985a5-d6eb-4f70-add9-9123b5554d4d"
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "ab054825-2bb0-4b65-addf-7bc0bdeb9d9b"
        },
        "target": {
          "id": "27d83f31-6f18-43b6-9e59-b9c390d22cda",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "59.756%",
              "dy": "95.833%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "after 1 ms [column == 15 && row == 0] \n/ row = 1; column = 0"
              }
            },
            "position": {
              "distance": 0.45698924731182794,
              "offset": 116,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "3"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "b913be20-387b-4126-83f6-cc46aec0a374",
        "z": 30,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [],
        "parent": "ecbbc96e-feb3-4712-8c3c-e66e2177eb3a"
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "27d83f31-6f18-43b6-9e59-b9c390d22cda"
        },
        "target": {
          "id": "ab054825-2bb0-4b65-addf-7bc0bdeb9d9b",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "48%",
              "dy": "11.905%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "after 1 ms"
              }
            },
            "position": {
              "offset": 40,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "e00fbb0f-a1c1-401d-94f9-465a28a0d7e5",
        "z": 30,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [],
        "parent": "ecbbc96e-feb3-4712-8c3c-e66e2177eb3a"
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "ab054825-2bb0-4b65-addf-7bc0bdeb9d9b"
        },
        "target": {
          "id": "10c03158-ced1-4cda-a1a2-436b1d0c3f0d",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "45.455%",
              "dy": "78.873%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "after 1 ms [column == 15 && row == 1] / flag = false; row = 0; column = 0"
              }
            },
            "position": {
              "distance": 0.44963491040974424,
              "offset": -19,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "c65353cc-bb54-4b9d-908b-1d16b59f0d2c",
        "z": 30,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [],
        "parent": "ecbbc96e-feb3-4712-8c3c-e66e2177eb3a"
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "10c03158-ced1-4cda-a1a2-436b1d0c3f0d"
        },
        "target": {
          "id": "27d83f31-6f18-43b6-9e59-b9c390d22cda",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "12.5%",
              "dy": "52.874%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "update / flag = true; row = 0; column = 0"
              }
            },
            "position": {}
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "33cf84e7-ce66-4efc-8c45-88dd21302130",
        "z": 30,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [],
        "parent": "ecbbc96e-feb3-4712-8c3c-e66e2177eb3a"
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "add985a5-d6eb-4f70-add9-9123b5554d4d"
        },
        "target": {
          "id": "10c03158-ced1-4cda-a1a2-436b1d0c3f0d",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "50.649%",
              "dy": "14.085%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {},
            "position": {}
          },
          {
            "attrs": {
              "label": {
                "text": "1"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "19c847db-3c48-42bd-a1c4-4b3399a3e5e9",
        "z": 30,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [],
        "parent": "ecbbc96e-feb3-4712-8c3c-e66e2177eb3a"
      },
      {
        "type": "Transition",
        "attrs": {},
        "source": {
          "id": "ab054825-2bb0-4b65-addf-7bc0bdeb9d9b"
        },
        "target": {
          "id": "ab054825-2bb0-4b65-addf-7bc0bdeb9d9b",
          "anchor": {
            "name": "topLeft",
            "args": {
              "dx": "88.571%",
              "dy": "63.095%",
              "rotate": true
            }
          },
          "priority": true
        },
        "connector": {
          "name": "rounded"
        },
        "labels": [
          {
            "attrs": {
              "text": {
                "text": "after 1 ms [column < 15] / column += 1"
              }
            },
            "position": {
              "distance": 0.41781964400288063,
              "offset": 22,
              "angle": 0
            }
          },
          {
            "attrs": {
              "label": {
                "text": "2"
              }
            }
          },
          {
            "attrs": {}
          },
          {
            "attrs": {}
          }
        ],
        "id": "c2e8106d-64a6-4677-a9d4-3bc933c7da20",
        "z": 30,
        "router": {
          "name": "orthogonal"
        },
        "vertices": [],
        "parent": "ab054825-2bb0-4b65-addf-7bc0bdeb9d9b"
      }
    ]
  },
  "genModel": {
    "generator": {
      "type": "create::c",
      "features": {
        "Outlet": {
          "targetProject": "",
          "targetFolder": "",
          "libraryTargetFolder": "",
          "skipLibraryFiles": "",
          "apiTargetFolder": ""
        },
        "LicenseHeader": {
          "licenseText": ""
        },
        "FunctionInlining": {
          "inlineReactions": false,
          "inlineEntryActions": false,
          "inlineExitActions": false,
          "inlineEnterSequences": false,
          "inlineExitSequences": false,
          "inlineChoices": false,
          "inlineEnterRegion": false,
          "inlineExitRegion": false,
          "inlineEntries": false
        },
        "OutEventAPI": {
          "observables": false,
          "getters": false
        },
        "IdentifierSettings": {
          "moduleName": "TaskDisplay",
          "statemachinePrefix": "taskDisplay",
          "separator": "_",
          "headerFilenameExtension": "h",
          "sourceFilenameExtension": "c"
        },
        "Tracing": {
          "enterState": false,
          "exitState": false,
          "generic": false
        },
        "Includes": {
          "useRelativePaths": false,
          "generateAllSpecifiedIncludes": false
        },
        "GeneratorOptions": {
          "userAllocatedQueue": false,
          "metaSource": false
        },
        "GeneralFeatures": {
          "timerService": false,
          "timerServiceTimeType": ""
        },
        "Debug": {
          "dumpSexec": false
        }
      }
    }
  }
}