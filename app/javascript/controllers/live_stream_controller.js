import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

// Connects to data-controller="live-stream"
export default class extends Controller {
  static targets = ["videoPreview", "enableCamera", "disableCamera"]

  enableCamera(e) {
    e.preventDefault()
    
    navigator.mediaDevices
    .getUserMedia({
        video: true,
        // audio: true,
    })
    .then((stream) => {
        this.enableCameraTarget.classList.add("hidden")
        this.disableCameraTarget.classList.remove("hidden")
        // Changing the source of video to current stream.
        this.videoPreviewTarget.srcObject = stream;
        this.videoPreviewTarget.addEventListener("loadedmetadata", () => {
            this.videoPreviewTarget.play();
        });

        this.connectToActionCable()
        setTimeout(() => {
          
        }, 50)
    })
    .catch(alert);
  }

  disableCamera(e) {
    e.preventDefault()
    this.enableCameraTarget.classList.remove("hidden")
    this.disableCameraTarget.classList.add("hidden")

    const stream = this.videoPreviewTarget.srcObject;
    const tracks = stream.getTracks();

    tracks.forEach((track) => {
      track.stop();
    });

    this.videoPreviewTarget.srcObject = null;
  }

  connectToActionCable() {
    this.liveStreamChannel = consumer.subscriptions.create("LiveStreamChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log("Connected to stream")
      },
    
      disconnected() {
        // Called when the subscription has been terminated by the server
      },
    
      async received(data) {
        // Called when there's incoming data on the websocket for this channel
        if (data.answer) {
          const remoteDesc = new RTCSessionDescription(message.answer);
          await peerConnection.setRemoteDescription(remoteDesc);
        }
      }
    });
  }

  async makeCall() {
    const configuration = {'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]}
    const peerConnection = new RTCPeerConnection(configuration);
    const offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);
    this.liveStreamChannel.send({'offer': offer});
  }
}
