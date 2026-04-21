pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root
    // Fallback implementation for environments where Quickshell.Services.Polkit
    // is not available in the installed quickshell build.
    property bool active: false
    property var flow: QtObject {
        property string message: ""
        property string inputPrompt: ""
        property bool responseVisible: false
        property string iconName: ""
        function cancelAuthenticationRequest() {}
        function submit(_input) {}
    }
    property bool interactionAvailable: false
    property string cleanMessage: {
        if (!root.flow) return "";
        return root.flow.message.endsWith(".")
            ? root.flow.message.slice(0, -1)
            : root.flow.message
    }
    property string cleanPrompt: {
        const inputPrompt = PolkitService.flow?.inputPrompt.trim() ?? "";
        const cleanedInputPrompt = inputPrompt.endsWith(":") ? inputPrompt.slice(0, -1) : inputPrompt;
        const usePasswordChars = !PolkitService.flow?.responseVisible ?? true
        return cleanedInputPrompt || (usePasswordChars ? Translation.tr("Password") : Translation.tr("Input"))
    }

    function cancel() {
        root.flow.cancelAuthenticationRequest()
        root.interactionAvailable = false
    }

    function submit(string) {
        root.flow.submit(string)
        root.interactionAvailable = false
    }
}
