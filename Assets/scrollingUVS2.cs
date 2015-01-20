using UnityEngine;
using System.Collections;

public class skyAnimate : MonoBehaviour {
	
	public float scrollSpeed = 0.02f;
	
	void Update()
	{
		float offset = Time.time * scrollSpeed;
		renderer.material.mainTextureOffset = new Vector2(offset % 1, 0);
	}
}