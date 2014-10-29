using UnityEngine;
using System.Collections;

[RequireComponent(typeof(AudioSource))]
public class PlayAudio : MonoBehaviour {
	void Start() {
		audio.Play();
		//audio.Play(44100);
	}
}