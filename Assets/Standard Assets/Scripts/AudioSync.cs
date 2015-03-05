using UnityEngine;
using System.Collections;

public class AudioSync : MonoBehaviour {
	//set these in the inspector!
	public AudioSource master;
	public AudioSource slave;
	public AudioSource slave2;
	public AudioSource slave3;
	public AudioSource slave4;
	
	void Update() {
		slave.timeSamples = master.timeSamples;
		slave2.timeSamples = master.timeSamples;
		slave3.timeSamples = master.timeSamples;
		slave4.timeSamples = master.timeSamples;
	}
}