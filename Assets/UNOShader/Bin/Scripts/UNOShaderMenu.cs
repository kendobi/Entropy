using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;

public class UnoshaderMenu : Editor
{
	[MenuItem("Help/UNOShader")]
	static void UnlitHelpSite()
	{
		Application.OpenURL ("http://www.unoverse.com/tools");
	}
}
